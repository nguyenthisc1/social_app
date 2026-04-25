import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../../user/domain/entites/user_entity.dart';
import '../entities/auth_tokens.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String username,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<bool> isAuthenticated();

  Future<AuthTokens?> getAuthTokens();

  Future<Either<Failure, AuthTokens>> refreshToken();

  Future<Either<Failure, UserEntity>> updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
  });

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, void>> requestPasswordReset({required String email});

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<Either<Failure, void>> verifyEmail({required String token});
}
