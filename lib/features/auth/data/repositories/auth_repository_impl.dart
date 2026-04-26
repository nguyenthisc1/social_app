import 'package:social_app/core/data/http/network_info.dart';
import 'package:social_app/core/domain/exceptions/exception_base.dart';
import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/features/auth/data/datasources/remote/auth_firebase_remote_data_souce.dart';
import 'package:social_app/features/auth/domain/auth_exceptions.dart';
import 'package:social_app/features/user/data/models/user_model.dart';

import '../../../user/data/mappers/user_mapper.dart';
import '../../../user/domain/entites/user_entity.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_data_source.dart';
import '../mappers/auth_tokens_mapper.dart';
import '../models/auth_tokens_model.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseRemoteDataSource remoteDataSource;
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
      throw AuthUnauthorizedException(
        userMessage: 'Your session has expired. Please sign in again.',
        debugMessage: 'No cached authentication tokens found.',
      );
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
      final data = await remoteDataSource.refreshToken(
        refreshToken: refreshToken,
      );

      final newTokens = AuthTokensModel.fromJson(
        data['tokens'] as Map<String, dynamic>,
      );
      await localDataSource.cacheTokens(newTokens);
      return newTokens.accessToken;
    } on AuthException {
      await localDataSource.clearAllData();
      rethrow;
    } catch (e) {
      await localDataSource.clearAllData();
      throw AuthTokenException(
        cause: e,
        userMessage: 'Your session has expired. Please sign in again.',
        debugMessage: 'Token refresh failed in auth repository.',
      );
    }
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network unavailable during login.',
      );
    }

    final data = await remoteDataSource.login(email: email, password: password);
    final userModel = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    final tokensModel = AuthTokensModel.fromJson(
      data['tokens'] as Map<String, dynamic>,
    );

    await localDataSource.cacheUser(userModel);
    await localDataSource.cacheTokens(tokensModel);

    return UserMapper.toEntity(userModel);
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String username,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network unavailable during registration.',
      );
    }

    final data = await remoteDataSource.register(
      email: email,
      username: username,
      password: password,
    );

    final userModel = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    final tokensModel = AuthTokensModel.fromJson(
      data['tokens'] as Map<String, dynamic>,
    );

    await localDataSource.cacheUser(userModel);
    await localDataSource.cacheTokens(tokensModel);

    return UserMapper.toEntity(userModel);
  }

  @override
  Future<void> logout() async {
    try {
      final tokens = await localDataSource.getCachedTokens();
      final user = await localDataSource.getCachedUser();

      if (tokens != null && user != null && await networkInfo.isConnected) {
        await remoteDataSource.logout(user.id);
      }

      await localDataSource.clearAllData();
    } on ExceptionBase {
      rethrow;
    } catch (e) {
      throw CacheException(
        cause: e,
        userMessage: 'Unable to clear your session.',
        debugMessage: 'Failed to logout and clear auth cache.',
      );
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        if (await networkInfo.isConnected) {
          try {
            final accessToken = await _getValidAccessToken();
            final userModel = await remoteDataSource.getCurrentUser(
              accessToken: accessToken,
            );
            await localDataSource.cacheUser(userModel);
            return UserMapper.toEntity(userModel);
          } catch (_) {
            return UserMapper.toEntity(cachedUser);
          }
        }
        return UserMapper.toEntity(cachedUser);
      }

      if (!await networkInfo.isConnected) {
        throw NetworkException(
          userMessage: 'No internet connection.',
          debugMessage: 'Network unavailable while loading current user.',
        );
      }

      final accessToken = await _getValidAccessToken();
      final userModel = await remoteDataSource.getCurrentUser(
        accessToken: accessToken,
      );

      await localDataSource.cacheUser(userModel);
      return UserMapper.toEntity(userModel);
    } on ExceptionBase {
      rethrow;
    } catch (e) {
      throw CacheException(
        cause: e,
        userMessage: 'Unable to load your profile.',
        debugMessage: 'Failed to get current user in auth repository.',
      );
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
  Future<AuthTokens> refreshToken() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network unavailable during token refresh.',
      );
    }

    final currentTokens = await localDataSource.getCachedTokens();
    if (currentTokens == null) {
      throw AuthTokenException(
        userMessage: 'Your session has expired. Please sign in again.',
        debugMessage: 'No refresh token available in local cache.',
      );
    }

    final data = await remoteDataSource.refreshToken(
      refreshToken: currentTokens.refreshToken,
    );

    final tokensModel = AuthTokensModel.fromJson(
      data['tokens'] as Map<String, dynamic>,
    );

    await localDataSource.cacheTokens(tokensModel);

    return AuthTokensMapper.fromModel(tokensModel);
  }

  @override
  Future<UserEntity> updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network unavailable during profile update.',
      );
    }

    final accessToken = await _getValidAccessToken();
    final userModel = await remoteDataSource.updateProfile(
      accessToken: accessToken,
      displayName: displayName,
      bio: bio,
      avatarUrl: avatarUrl,
    );

    await localDataSource.cacheUser(userModel);
    return UserMapper.toEntity(userModel);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network unavailable during password change.',
      );
    }

    final accessToken = await _getValidAccessToken();
    await remoteDataSource.changePassword(
      accessToken: accessToken,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network unavailable during password reset request.',
      );
    }

    await remoteDataSource.requestPasswordReset(email: email);
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network unavailable during password reset.',
      );
    }

    await remoteDataSource.resetPassword(
      token: token,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> verifyEmail({required String token}) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network unavailable during email verification.',
      );
    }

    await remoteDataSource.verifyEmail(token: token);
  }
}
