import 'package:social_app/features/user/data/datasources/local/user_local_data_source.dart';
import 'package:social_app/features/user/data/datasources/remote/user_remote_data_source.dart';
import 'package:social_app/features/user/data/mappers/user_mapper.dart';
import 'package:social_app/features/user/domain/entites/user_entity.dart';
import 'package:social_app/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  const UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<UserEntity?> getUserById(String id) async {
    try {
      final model = await _remoteDataSource.getUserById(id);
      if (model != null) {
        await _localDataSource.cacheUser(model);
        return UserMapper.toEntity(model);
      }
    } catch (_) {
      // getCachedUsersByIds returns Map<String, UserModel>
      final cachedUsers = await _localDataSource.getCachedUsersByIds([id]);
      if (cachedUsers.isNotEmpty) {
        final firstModel = cachedUsers.values.first;
        return UserMapper.toEntity(firstModel);
      }
    }

    return null;
  }

  @override
  Future<List<UserEntity>> getUsersByIds(List<String> ids) async {
    final uniqueIds = ids.where((id) => id.isNotEmpty).toSet().toList();
    if (uniqueIds.isEmpty) {
      return const [];
    }

    final cachedUsers = await _localDataSource.getCachedUsersByIds(uniqueIds);
    final usersById = <String, UserEntity>{};

    for (final cachedUser in cachedUsers.values) {
      final user = UserMapper.toEntity(cachedUser);
      usersById[user.id] = user;
    }

    final missingIds = uniqueIds
        .where((id) => !usersById.containsKey(id))
        .toList();

    if (missingIds.isNotEmpty) {
      final remoteUsers = await _remoteDataSource.getUsersByIds(missingIds);

      for (final remoteUser in remoteUsers) {
        await _localDataSource.cacheUser(remoteUser);
        final user = UserMapper.toEntity(remoteUser);
        usersById[user.id] = user;
      }
    }

    return uniqueIds
        .map((id) => usersById[id])
        .whereType<UserEntity>()
        .toList();
  }

  @override
  Future<UserEntity> getUserProfile() async {
    try {
      final model = await _remoteDataSource.getUserProfile();
      await _localDataSource.cacheUser(model);
      return UserMapper.toEntity(model);
    } catch (e) {
      final cachedModel = await _localDataSource.getCachedUser();
      if (cachedModel == null) {
        throw Exception('No cached user available');
      }
      return UserMapper.toEntity(cachedModel);
    }
  }

  @override
  Future<List<UserEntity>> searchUser(String search) async {
    final models = await _remoteDataSource.searchUser(search);

    return models.map(UserMapper.toEntity).toList();
  }

  @override
  Future<UserEntity> updateUserProfile(UserEntity user) {
    throw UnimplementedError();
  }
}
