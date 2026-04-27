import 'package:social_app/core/network/base_response.dart';
import 'package:social_app/features/user/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  /// Login with email and password
  Future<BaseResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<BaseResponse<Map<String, dynamic>>> register({
    required String email,
    required String username,
    required String password,
  });

  /// Logout current user
  Future<BaseResponse<void>> logout(String userId);

  /// Get current user
  Future<BaseResponse<UserModel>> getCurrentUser({required String accessToken});

  /// Update user profile
  Future<BaseResponse<UserModel>> updateProfile({
    required String accessToken,
    String? displayName,
    String? bio,
    String? avatarUrl,
  });

  /// Change password
  Future<BaseResponse<void>> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  });

  /// Request password reset
  Future<BaseResponse<void>> requestPasswordReset({required String email});

  /// Reset password with token
  Future<BaseResponse<void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verify email with token
  Future<BaseResponse<void>> verifyEmail({required String token});

  /// Refresh access token
  Future<BaseResponse<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  });
}
