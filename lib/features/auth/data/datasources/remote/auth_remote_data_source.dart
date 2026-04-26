import 'package:social_app/core/data/http/http_response.dart';
import 'package:social_app/features/user/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  /// Login with email and password
  Future<HttpResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<HttpResponse<Map<String, dynamic>>> register({
    required String email,
    required String username,
    required String password,
  });

  /// Logout current user
  Future<HttpResponse<void>> logout(String userId);

  /// Get current user
  Future<HttpResponse<UserModel>> getCurrentUser({required String accessToken});

  /// Update user profile
  Future<HttpResponse<UserModel>> updateProfile({
    required String accessToken,
    String? displayName,
    String? bio,
    String? avatarUrl,
  });

  /// Change password
  Future<HttpResponse<void>> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  });

  /// Request password reset
  Future<HttpResponse<void>> requestPasswordReset({required String email});

  /// Reset password with token
  Future<HttpResponse<void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verify email with token
  Future<HttpResponse<void>> verifyEmail({required String token});

  /// Refresh access token
  Future<HttpResponse<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  });
}
