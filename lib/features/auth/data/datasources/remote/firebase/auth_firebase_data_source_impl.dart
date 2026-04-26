import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:social_app/features/auth/data/datasources/remote/auth_firebase_remote_data_souce.dart';
import 'package:social_app/features/auth/domain/auth_exceptions.dart';
import 'package:social_app/features/user/data/models/user_model.dart';

class AuthFirebaseDataSourceImpl implements AuthFirebaseRemoteDataSource {
  AuthFirebaseDataSourceImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Future<Map<String, dynamic>> login({
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
        throw AuthSignInException(
          cause: null,
          userMessage: 'User not found. Please check your credentials.',
          debugMessage:
              'FirebaseAuth returned null user on login for email: $email',
        );
      }

      final userModel = await _loadUserModel(user);
      final token = await user.getIdToken();

      return {
        'user': userModel.toJson(),
        'tokens': _buildTokens(token, user.refreshToken),
      };
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthSignInException(
        cause: e,
        userMessage: 'Failed to sign in. Please check your email and password.',
        debugMessage:
            'FirebaseAuthException on login: ${e.code} - ${e.message}',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthSignInException(
        cause: e,
        userMessage: 'An unknown error occurred while signing in.',
        debugMessage: 'Generic exception on login: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> register({
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
        throw AuthSignUpException(
          cause: null,
          userMessage: 'Failed to create user account. Please try again.',
          debugMessage:
              'FirebaseAuth returned null user on register for email: $email',
        );
      }

      final userModel = UserModel(
        id: user.uid,
        username: username,
        email: email,
        isOnline: true,
        lastSeen: Timestamp.now(),
        createdAt: Timestamp.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());

      final token = await user.getIdToken();

      return {
        'user': userModel.toJson(),
        'tokens': _buildTokens(token, user.refreshToken),
      };
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthSignUpException(
        cause: e,
        userMessage: 'Failed to register. This email may already be in use.',
        debugMessage:
            'FirebaseAuthException on register: ${e.code} - ${e.message}',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthSignUpException(
        cause: e,
        userMessage: 'An unknown error occurred while registering.',
        debugMessage: 'Generic exception on register: $e',
      );
    }
  }

  @override
  Future<void> logout(String userId) async {
    try {
      await _firebaseAuth.signOut();
      // No HttpResponse; just return.
      return;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthSignOutException(
        cause: e,
        userMessage: 'Failed to log out. Please try again.',
        debugMessage:
            'FirebaseAuthException during logout: ${e.code} - ${e.message}',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthSignOutException(
        cause: e,
        userMessage: 'Unknown error occurred during logout.',
        debugMessage: 'Unexpected exception during logout: $e',
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser({required String accessToken}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthUnauthorizedException(
          cause: null,
          userMessage: 'Not logged in. Please authenticate again.',
          debugMessage: 'FirebaseAuth.currentUser is null on getCurrentUser.',
        );
      }

      final userModel = await _loadUserModel(user);
      return userModel;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthUnauthorizedException(
        cause: e,
        userMessage: 'Session expired or invalid. Please login again.',
        debugMessage:
            'FirebaseAuthException on getCurrentUser: ${e.code} - ${e.message}',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthUnauthorizedException(
        cause: e,
        userMessage: 'Failed to load current user.',
        debugMessage: 'Unexpected error on getCurrentUser: $e',
      );
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String accessToken,
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthUnauthorizedException(
          cause: null,
          userMessage: 'Not logged in. Please authenticate again.',
          debugMessage: 'FirebaseAuth.currentUser is null in updateProfile.',
        );
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
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(updateData, SetOptions(merge: true));
      }

      final userModel = await _loadUserModel(user);
      return userModel;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthUnauthorizedException(
        cause: e,
        userMessage: 'Failed to update profile. Please try again.',
        debugMessage:
            'FirebaseAuthException on updateProfile: ${e.code} - ${e.message}',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthUnauthorizedException(
        cause: e,
        userMessage: 'Failed to update profile.',
        debugMessage: 'Unexpected error in updateProfile: $e',
      );
    }
  }

  @override
  Future<void> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null || user.email == null) {
        throw AuthUnauthorizedException(
          cause: null,
          userMessage: 'Not logged in. Please authenticate again.',
          debugMessage:
              'FirebaseAuth.currentUser is null or missing email in changePassword.',
        );
      }

      final credential = firebase_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      // No HttpResponse; just return.
      return;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthUnauthorizedException(
        cause: e,
        userMessage:
            'Password change failed. Please check your current password.',
        debugMessage:
            'FirebaseAuthException on changePassword: ${e.code} - ${e.message}',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthUnauthorizedException(
        cause: e,
        userMessage: 'Failed to change password.',
        debugMessage: 'Unexpected error in changePassword: $e',
      );
    }
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      // No HttpResponse; just return.
      return;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthPasswordResetException(
        cause: e,
        userMessage: 'Could not send password reset email. Check your address.',
        debugMessage:
            'FirebaseAuthException during requestPasswordReset: ${e.code} - ${e.message}',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthPasswordResetException(
        cause: e,
        userMessage: 'Unknown error occurred while requesting password reset.',
        debugMessage: 'Unexpected exception in requestPasswordReset: $e',
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
        code: token,
        newPassword: newPassword,
      );

      // No HttpResponse; just return.
      return;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthPasswordResetException(
        cause: e,
        userMessage:
            'Failed to reset password. Please try again or request a new reset email.',
        debugMessage:
            'FirebaseAuthException on resetPassword: ${e.code} - ${e.message}',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthPasswordResetException(
        cause: e,
        userMessage: 'Failed to reset password.',
        debugMessage: 'Unexpected error in resetPassword: $e',
      );
    }
  }

  @override
  Future<void> verifyEmail({required String token}) async {
    try {
      await _firebaseAuth.applyActionCode(token);
      // No HttpResponse; just return.
      return;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthUnauthorizedException(
        cause: e,
        userMessage:
            'Failed to verify email. The verification link may be invalid or expired.',
        debugMessage:
            'FirebaseAuthException on verifyEmail: ${e.code} - ${e.message}',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthUnauthorizedException(
        cause: e,
        userMessage: 'Failed to verify email address.',
        debugMessage: 'Unexpected error on verifyEmail: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthTokenException(
          cause: null,
          userMessage: 'Not logged in. Please sign in again.',
          debugMessage: 'FirebaseAuth.currentUser is null in refreshToken.',
        );
      }

      final newAccessToken = await user.getIdToken(true);
      return {'tokens': _buildTokens(newAccessToken, user.refreshToken)};
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthTokenException(
        cause: e,
        userMessage: 'Token refresh failed. Please log in again.',
        debugMessage:
            'FirebaseAuthException on refreshToken: ${e.code} - ${e.message}',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthTokenException(
        cause: e,
        userMessage: 'Token refresh failed.',
        debugMessage: 'Unexpected error in refreshToken: $e',
      );
    }
  }

  Future<UserModel> _loadUserModel(firebase_auth.User user) async {
    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    final data = snapshot.data();
    if (data == null) {
      throw AuthNotFoundException(
        cause: null,
        userMessage: 'User profile not found.',
        debugMessage: 'Firestore missing user doc for uid: ${user.uid}',
      );
    }

    return UserModel.fromJson({
      ...data,
      'id': user.uid,
      '_id': user.uid,
      'email': user.email ?? data['email'],
    });
  }

  Map<String, dynamic> _buildTokens(String? accessToken, String? refreshToken) {
    return {
      'access_token': accessToken ?? '',
      'refresh_token': refreshToken ?? '',
      'expires_at': DateTime.now()
          .add(const Duration(hours: 1))
          .toIso8601String(),
      'token_type': 'Bearer',
    };
  }
}
