import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/user.dart';
import '../entities/auth_tokens.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String email,
    required String username,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  Future<bool> isAuthenticated();

  Future<AuthTokens?> getAuthTokens();

  Future<Either<Failure, AuthTokens>> refreshToken();

  Future<Either<Failure, User>> updateProfile({
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
