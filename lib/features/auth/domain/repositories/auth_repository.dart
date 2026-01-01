import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/user.dart';
import '../entities/auth_tokens.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<Either<Failure, User>> register({
    required String email,
    required String username,
    required String password,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current authenticated user
  Future<Either<Failure, User>> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Get current auth tokens
  Future<AuthTokens?> getAuthTokens();

  /// Refresh access token
  Future<Either<Failure, AuthTokens>> refreshToken();

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Request password reset
  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
  });

  /// Reset password with token
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verify email with token
  Future<Either<Failure, void>> verifyEmail({
    required String token,
  });
}

