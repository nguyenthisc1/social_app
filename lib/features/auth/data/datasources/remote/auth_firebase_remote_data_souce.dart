import 'package:social_app/features/user/data/models/user_model.dart';

abstract interface class AuthFirebaseRemoteDataSource {
  /// Login with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
  });

  /// Logout current user
  Future<void> logout(String userId);

  /// Get current user
  Future<UserModel> getCurrentUser({required String accessToken});

  /// Update user profile
  Future<UserModel> updateProfile({
    required String accessToken,
    String? displayName,
    String? bio,
    String? avatarUrl,
  });

  /// Change password
  Future<void> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  });

  /// Request password reset
  Future<void> requestPasswordReset({required String email});

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verify email with token
  Future<void> verifyEmail({required String token});

  /// Refresh access token
  Future<Map<String, dynamic>> refreshToken({required String refreshToken});
}
