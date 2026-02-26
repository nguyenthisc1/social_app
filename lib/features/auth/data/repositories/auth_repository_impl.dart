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

  Future<String>? _refreshInProgress;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  /// Returns a valid access token, automatically refreshing if expired or about to expire.
  Future<String> _getValidAccessToken() async {
    final tokens = await localDataSource.getCachedTokens();
    if (tokens == null) {
      throw const UnauthorizedException(message: 'No authentication tokens');
    }

    if (!tokens.isExpired && !tokens.willExpireSoon) {
      return tokens.accessToken;
    }

    return _refreshAndGetAccessToken(tokens.refreshToken);
  }

  /// Deduplicates concurrent refresh calls so only one network request is made.
  Future<String> _refreshAndGetAccessToken(String refreshToken) async {
    _refreshInProgress ??= _performTokenRefresh(refreshToken);
    try {
      return await _refreshInProgress!;
    } finally {
      _refreshInProgress = null;
    }
  }

  /// Executes the actual refresh request and caches the new tokens.
  Future<String> _performTokenRefresh(String refreshToken) async {
    try {
      final response = await remoteDataSource.refreshToken(
        refreshToken: refreshToken,
      );
      final data = response.data;
      if (data == null) {
        await localDataSource.clearAllData();
        throw const UnauthorizedException(message: 'Token refresh failed');
      }

      final newTokens = AuthTokensModel.fromJson(
        data['tokens'] as Map<String, dynamic>,
      );
      await localDataSource.cacheTokens(newTokens);
      return newTokens.accessToken;
    } on UnauthorizedException {
      await localDataSource.clearAllData();
      rethrow;
    } catch (e) {
      await localDataSource.clearAllData();
      throw const UnauthorizedException(message: 'Token refresh failed');
    }
  }

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
      final userModel = UserModel.fromJson(
        data['user'] as Map<String, dynamic>,
      );
      final tokensModel = AuthTokensModel.fromJson(
        data['tokens'] as Map<String, dynamic>,
      );

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
      final userModel = UserModel.fromJson(
        data['user'] as Map<String, dynamic>,
      );
      final tokensModel = AuthTokensModel.fromJson(
        data['tokens'] as Map<String, dynamic>,
      );

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
  Future<Either<Failure, void>> logout() async {
    try {
      final tokens = await localDataSource.getCachedTokens();
      final user = await localDataSource.getCachedUser();

      if (tokens != null && user != null && await networkInfo.isConnected) {
        final response = await remoteDataSource.logout(user.id);
        if (response.success == true) {
          await localDataSource.clearAllData();

          // ignore: void_checks
          return const Right({'success': true});
        }
      }

      // In all cases (no tokens/user/network, or remote logout not successful), always clear local data
      await localDataSource.clearAllData();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to logout: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        if (await networkInfo.isConnected) {
          try {
            final accessToken = await _getValidAccessToken();
            final response = await remoteDataSource.getCurrentUser(
              accessToken: accessToken,
            );

            final userModel = response.data;
            if (userModel != null) {
              await localDataSource.cacheUser(userModel);
              return Right(UserMapper.fromModel(userModel));
            }
          } catch (_) {
            return Right(UserMapper.fromModel(cachedUser));
          }
        }
        return Right(UserMapper.fromModel(cachedUser));
      }

      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final accessToken = await _getValidAccessToken();
      final response = await remoteDataSource.getCurrentUser(
        accessToken: accessToken,
      );

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
    if (tokens == null) return false;
    if (!tokens.isExpired) return true;

    try {
      await _getValidAccessToken();
      return true;
    } catch (_) {
      return false;
    }
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

      final data = response.data;

      if (data == null) {
        return const Left(
          ServerFailure(message: 'RefreshToken failed: no data returned'),
        );
      }

      final tokensModel = AuthTokensModel.fromJson(
        data['tokens'] as Map<String, dynamic>,
      );

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
      final accessToken = await _getValidAccessToken();

      final response = await remoteDataSource.updateProfile(
        accessToken: accessToken,
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
      final accessToken = await _getValidAccessToken();

      await remoteDataSource.changePassword(
        accessToken: accessToken,
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
      return Left(
        ServerFailure(message: 'Failed to request password reset: $e'),
      );
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
  Future<Either<Failure, void>> verifyEmail({required String token}) async {
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
