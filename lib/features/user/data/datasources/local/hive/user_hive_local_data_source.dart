import 'package:hive/hive.dart';
import 'package:social_app/features/user/data/datasources/local/user_local_data_source.dart';
import 'package:social_app/features/user/data/models/user_model.dart';
import 'package:social_app/features/user/domain/user_exceptions.dart' show UserCacheException;

class UserHiveLocalDataSource implements UserLocalDataSource {
  static const _kUserBox = 'user_box';

  String _currentUserKey() => 'current_user_profile';
  String _userByIdKey(String userId) => 'user_$userId';

  Future<Box<dynamic>> _openBox() async {
    return Hive.isBoxOpen(_kUserBox)
        ? Hive.box<dynamic>(_kUserBox)
        : Hive.openBox<dynamic>(_kUserBox);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final box = await _openBox();
      final serializedUser = _serializeUser(user);

      await Future.wait([
        box.put(_currentUserKey(), serializedUser),
        box.put(_userByIdKey(user.id), serializedUser),
      ]);
    } catch (e) {
      throw UserCacheException(
        debugMessage: 'Failed to cache user: $e',
        cause: e,
      );
    }
  }

  @override
  Future<Map<String, UserModel>> getCachedUsersByIds(List<String> ids) async {
    try {
      final box = await _openBox();
      final cachedUsers = <String, UserModel>{};

      for (final id in ids.toSet()) {
        final raw = box.get(_userByIdKey(id));
        if (raw is Map) {
          cachedUsers[id] = UserModel.fromJson(
            _deserializeUser(Map<String, dynamic>.from(raw)),
          );
        }
      }

      return cachedUsers;
    } catch (e) {
      throw UserCacheException(
        debugMessage: 'Failed to get cached users by ids: $e',
        cause: e,
      );
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final box = await _openBox();
      final raw = box.get(_currentUserKey());

      if (raw == null) return null;

      return UserModel.fromJson(
        _deserializeUser(Map<String, dynamic>.from(raw)),
      );
    } catch (e) {
      throw UserCacheException(
        debugMessage: 'Failed to get cached user: $e',
        cause: e,
      );
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      final box = await _openBox();
      await box.delete(_currentUserKey());
    } catch (e) {
      throw UserCacheException(
        debugMessage: 'Failed to clear cached user: $e',
        cause: e,
      );
    }
  }

  Map<String, dynamic> _serializeUser(UserModel model) {
    return {
      'id': model.id,
      'username': model.username,
      'email': model.email,
      'avatarUrl': model.avatarUrl,
      'bio': model.bio,
      'friends': model.friends,
      'following': model.following,
      'followers': model.followers,
      'isOnline': model.isOnline,
    };
  }

  Map<String, dynamic> _deserializeUser(Map<String, dynamic> json) {
    return {
      'id': json['id'] as String,
      'username': json['username'] as String,
      'email': json['email'] as String,
      'avatarUrl': json['avatarUrl'] as String?,
      'bio': json['bio'] as String?,
      'friends':
          (json['friends'] as List<dynamic>?)?.cast<String>() ?? const [],
      'following':
          (json['following'] as List<dynamic>?)?.cast<String>() ?? const [],
      'followers':
          (json['followers'] as List<dynamic>?)?.cast<String>() ?? const [],
      'isOnline': json['isOnline'] as bool? ?? false,
    };
  }
}
