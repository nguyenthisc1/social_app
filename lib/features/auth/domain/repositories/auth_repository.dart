import '../../../user/domain/entites/user_entity.dart';
import '../entities/auth_tokens.dart';

abstract interface class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String email,
    required String username,
    required String password,
  });

  Future<void> logout();

  Future<UserEntity> getCurrentUser();

  Future<bool> isAuthenticated();

  Future<AuthTokens?> getAuthTokens();

  Future<AuthTokens> refreshToken();

  Future<UserEntity> updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> requestPasswordReset({required String email});

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<void> verifyEmail({required String token});
}
