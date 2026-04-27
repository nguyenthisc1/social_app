import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:social_app/features/auth/data/models/auth_tokens_model.dart';
import 'package:social_app/features/user/data/models/user_model.dart';

class AuthPreferencesLocalDataSource implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _cachedUserKey = 'CACHED_USER';
  static const String _cachedTokensKey = 'CACHED_TOKENS';

  AuthPreferencesLocalDataSource({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    final jsonString = jsonEncode(_serializeUser(user));
    await sharedPreferences.setString(_cachedUserKey, jsonString);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(_cachedUserKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(_deserializeUser(json));
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
    await Future.wait([clearCachedUser(), clearCachedTokens()]);
  }

  Map<String, dynamic> _serializeUser(UserModel user) {
    return {
      'id': user.id,
      'username': user.username,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
      'bio': user.bio,
      'friends': user.friends,
      'following': user.following,
      'followers': user.followers,
      'lastSeen': user.lastSeen.millisecondsSinceEpoch,
      'createdAt': user.createdAt.millisecondsSinceEpoch,
      'isOnline': user.isOnline,
    };
  }

  Map<String, dynamic> _deserializeUser(Map<String, dynamic> json) {
    return {
      ...json,
      'lastSeen': {
        'millisecondsSinceEpoch': json['lastSeen'],
      },
      'createdAt': {
        'millisecondsSinceEpoch': json['createdAt'],
      },
    };
  }
}
