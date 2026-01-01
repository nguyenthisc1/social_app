import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/mappers/user_mapper.dart';
import '../../domain/mappers/auth_tokens_mapper.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/user_model.dart';
import '../models/auth_tokens_model.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );

      final data = response.data;
      if (data == null) {
        return const Left(
          ServerFailure(message: 'Login failed: no data returned'),
        );
      }

      // Extract user and tokens from response
      final userModel =
          UserModel.fromJson(data['user'] as Map<String, dynamic>);
      final tokensModel =
          AuthTokensModel.fromJson(data['tokens'] as Map<String, dynamic>);

      // Cache user and tokens
      await localDataSource.cacheUser(userModel);
      await localDataSource.cacheTokens(tokensModel);

      return Right(UserMapper.fromModel(userModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.register(
        email: email,
        username: username,
        password: password,
      );

      final data = response.data;
      if (data == null) {
        return const Left(
          ServerFailure(message: 'Registration failed: no data returned'),
        );
      }

      // Extract user and tokens from response
      final userModel =
          UserModel.fromJson(data['user'] as Map<String, dynamic>);
      final tokensModel =
          AuthTokensModel.fromJson(data['tokens'] as Map<String, dynamic>);

      // Cache user and tokens
      await localDataSource.cacheUser(userModel);
      await localDataSource.cacheTokens(tokensModel);

      return Right(UserMapper.fromModel(userModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final tokens = await localDataSource.getCachedTokens();

      if (tokens != null && await networkInfo.isConnected) {
        try {
          await remoteDataSource.logout(accessToken: tokens.accessToken);
        } catch (_) {
          // Ignore remote logout errors
        }
      }

      // Clear local data regardless of remote logout result
      await localDataSource.clearAllData();

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to logout: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Try to get cached user first
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        // If we have network, try to fetch fresh data
        if (await networkInfo.isConnected) {
          final tokens = await localDataSource.getCachedTokens();
          if (tokens != null && !tokens.isExpired) {
            try {
              final response = await remoteDataSource.getCurrentUser(
                  accessToken: tokens.accessToken);

              final userModel = response.data;
              if (userModel != null) {
                await localDataSource.cacheUser(userModel);
                return Right(UserMapper.fromModel(userModel));
              }
            } catch (_) {
              // Return cached user if remote fetch fails
              return Right(UserMapper.fromModel(cachedUser));
            }
          }
        }
        return Right(UserMapper.fromModel(cachedUser));
      }

      // No cached user, try remote
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final tokens = await localDataSource.getCachedTokens();
      if (tokens == null || tokens.isExpired) {
        return const Left(UnauthorizedFailure(message: 'No valid authentication'));
      }

      final response =
          await remoteDataSource.getCurrentUser(accessToken: tokens.accessToken);

      final userModel = response.data;
      if (userModel == null) {
        return const Left(
          ServerFailure(message: 'Failed to load user: no data returned'),
        );
      }

      await localDataSource.cacheUser(userModel);
      return Right(UserMapper.fromModel(userModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get user: $e'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final tokens = await localDataSource.getCachedTokens();
    return tokens != null && !tokens.isExpired;
  }

  @override
  Future<AuthTokens?> getAuthTokens() async {
    final tokens = await localDataSource.getCachedTokens();
    return tokens != null ? AuthTokensMapper.fromModel(tokens) : null;
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final currentTokens = await localDataSource.getCachedTokens();
      if (currentTokens == null) {
        return const Left(UnauthorizedFailure(message: 'No refresh token'));
      }

      final response = await remoteDataSource.refreshToken(
        refreshToken: currentTokens.refreshToken,
      );

      final tokensModel = response.data;
      if (tokensModel == null) {
        return const Left(
          ServerFailure(message: 'Token refresh failed: no data returned'),
        );
      }

      await localDataSource.cacheTokens(tokensModel);

      return Right(AuthTokensMapper.fromModel(tokensModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to refresh token: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final tokens = await localDataSource.getCachedTokens();
      if (tokens == null || tokens.isExpired) {
        return const Left(UnauthorizedFailure(message: 'Not authenticated'));
      }

      final response = await remoteDataSource.updateProfile(
        accessToken: tokens.accessToken,
        displayName: displayName,
        bio: bio,
        avatarUrl: avatarUrl,
      );

      final userModel = response.data;
      if (userModel == null) {
        return const Left(
          ServerFailure(message: 'Profile update failed: no data returned'),
        );
      }

      await localDataSource.cacheUser(userModel);
      return Right(UserMapper.fromModel(userModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update profile: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final tokens = await localDataSource.getCachedTokens();
      if (tokens == null || tokens.isExpired) {
        return const Left(UnauthorizedFailure(message: 'Not authenticated'));
      }

      await remoteDataSource.changePassword(
        accessToken: tokens.accessToken,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to change password: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.requestPasswordReset(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to request password reset: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to reset password: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String token,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.verifyEmail(token: token);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to verify email: $e'));
    }
  }
}
