import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/auth_tokens_model.dart';

/// Local data source for authentication
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();

  Future<void> cacheTokens(AuthTokensModel tokens);
  Future<AuthTokensModel?> getCachedTokens();
  Future<void> clearCachedTokens();

  Future<void> clearAllData();
}

/// Implementation of AuthLocalDataSource
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _cachedUserKey = 'CACHED_USER';
  static const String _cachedTokensKey = 'CACHED_TOKENS';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    final jsonString = jsonEncode(user.toJson());
    await sharedPreferences.setString(_cachedUserKey, jsonString);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(_cachedUserKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCachedUser() async {
    await sharedPreferences.remove(_cachedUserKey);
  }

  @override
  Future<void> cacheTokens(AuthTokensModel tokens) async {
    final jsonString = jsonEncode(tokens.toJson());
    await sharedPreferences.setString(_cachedTokensKey, jsonString);
  }

  @override
  Future<AuthTokensModel?> getCachedTokens() async {
    final jsonString = sharedPreferences.getString(_cachedTokensKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AuthTokensModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCachedTokens() async {
    await sharedPreferences.remove(_cachedTokensKey);
  }

  @override
  Future<void> clearAllData() async {
    await Future.wait([
      clearCachedUser(),
      clearCachedTokens(),
    ]);
  }
}

