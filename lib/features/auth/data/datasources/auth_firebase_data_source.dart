import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:social_app/core/errors/exceptions.dart';
import 'package:social_app/core/network/base_response.dart';
import 'package:social_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:social_app/features/user/data/models/user_model.dart';

class AuthFirebaseDataSource implements AuthRemoteDataSource {
  AuthFirebaseDataSource({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Future<BaseResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const UnauthorizedException(message: 'No user data found.');
      }

      final userModel = await _loadUserModel(user);
      final token = await user.getIdToken();

      return BaseResponse(
        success: true,
        message: 'Login successful.',
        data: {
          'user': userModel.toJson(),
          'tokens': _buildTokens(token, user.refreshToken),
        },
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Unknown error occurred during login: $e');
    }
  }

  @override
  Future<BaseResponse<Map<String, dynamic>>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const ServerException(message: 'Failed to create account.');
      }

      final userModel = UserModel(
        id: user.uid,
        username: username,
        email: email,
        isActive: true,
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

      final token = await user.getIdToken();

      return BaseResponse(
        success: true,
        message: 'Registration successful.',
        data: {
          'user': userModel.toJson(),
          'tokens': _buildTokens(token, user.refreshToken),
        },
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: 'Unknown error occurred during registration: $e',
      );
    }
  }

  @override
  Future<BaseResponse<void>> logout(String userId) async {
    try {
      await _firebaseAuth.signOut();
      return BaseResponse(
        success: true,
        message: 'Logout successful.',
        data: null,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Unknown error occurred during logout: $e');
    }
  }

  @override
  Future<BaseResponse<UserModel>> getCurrentUser({
    required String accessToken,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const UnauthorizedException(message: 'No authenticated user.');
      }

      final userModel = await _loadUserModel(user);
      return BaseResponse(
        success: true,
        message: 'Current user loaded successfully.',
        data: userModel,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to get current user: $e');
    }
  }

  @override
  Future<BaseResponse<UserModel>> updateProfile({
    required String accessToken,
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const UnauthorizedException(message: 'No authenticated user.');
      }

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (avatarUrl != null) {
        await user.updatePhotoURL(avatarUrl);
      }

      final updateData = <String, dynamic>{};
      if (displayName != null) updateData['username'] = displayName;
      if (bio != null) updateData['bio'] = bio;
      if (avatarUrl != null) updateData['avatarUrl'] = avatarUrl;
      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).set(
          updateData,
          SetOptions(merge: true),
        );
      }

      final userModel = await _loadUserModel(user);
      return BaseResponse(
        success: true,
        message: 'Profile updated successfully.',
        data: userModel,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to update profile: $e');
    }
  }

  @override
  Future<BaseResponse<void>> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null || user.email == null) {
        throw const UnauthorizedException(message: 'No authenticated user.');
      }

      final credential = firebase_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      return BaseResponse(
        success: true,
        message: 'Password changed successfully.',
        data: null,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to change password: $e');
    }
  }

  @override
  Future<BaseResponse<void>> requestPasswordReset({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return BaseResponse(
        success: true,
        message: 'Password reset email sent.',
        data: null,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: 'Unknown error occurred while requesting password reset: $e',
      );
    }
  }

  @override
  Future<BaseResponse<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
        code: token,
        newPassword: newPassword,
      );

      return BaseResponse(
        success: true,
        message: 'Password reset successfully.',
        data: null,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to reset password: $e');
    }
  }

  @override
  Future<BaseResponse<void>> verifyEmail({required String token}) async {
    try {
      await _firebaseAuth.applyActionCode(token);
      return BaseResponse(
        success: true,
        message: 'Email verified successfully.',
        data: null,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to verify email: $e');
    }
  }

  @override
  Future<BaseResponse<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const UnauthorizedException(message: 'No authenticated user.');
      }

      final newAccessToken = await user.getIdToken(true);
      return BaseResponse(
        success: true,
        message: 'Token refreshed successfully.',
        data: {
          'tokens': _buildTokens(newAccessToken, user.refreshToken),
        },
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnauthorizedException(message: 'Token refresh failed: $e');
    }
  }

  Future<UserModel> _loadUserModel(firebase_auth.User user) async {
    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    final data = snapshot.data();
    if (data == null) {
      throw const NotFoundException(message: 'User profile not found.');
    }

    return UserModel.fromJson({
      ...data,
      'id': user.uid,
      '_id': user.uid,
      'email': user.email ?? data['email'],
    });
  }

  Map<String, dynamic> _buildTokens(
    String? accessToken,
    String? refreshToken,
  ) {
    return {
      'access_token': accessToken ?? '',
      'refresh_token': refreshToken ?? '',
      'expires_at': DateTime.now()
          .add(const Duration(hours: 1))
          .toIso8601String(),
      'token_type': 'Bearer',
    };
  }

  AppException _mapFirebaseAuthException(
    firebase_auth.FirebaseAuthException exception,
  ) {
    switch (exception.code) {
      case 'invalid-email':
        return ValidationException(
          message: 'Email format is invalid.',
          errors: {'code': exception.code},
        );
      case 'invalid-credential':
      case 'wrong-password':
      case 'missing-password':
      case 'user-not-found':
        return ValidationException(
          message: 'Email or password is incorrect.',
          errors: {'code': exception.code},
        );
      case 'weak-password':
      case 'email-already-in-use':
      case 'requires-recent-login':
      case 'expired-action-code':
      case 'invalid-action-code':
        return ValidationException(
          message: exception.message ?? 'Authentication validation failed.',
          errors: {'code': exception.code},
        );
      case 'user-disabled':
        return UnauthorizedException(
          message: exception.message ?? 'This account has been disabled.',
        );
      default:
        return ServerException(
          message: exception.message ?? 'Firebase authentication failed.',
        );
    }
  }
}
