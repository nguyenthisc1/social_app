import 'package:social_app/features/user/data/datasources/local/user_local_data_source.dart';
import 'package:social_app/features/user/data/datasources/remote/user_remote_data_source.dart';
import 'package:social_app/features/user/data/mappers/user_mapper.dart';
import 'package:social_app/features/user/domain/entites/user.dart';
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
  Future<User?> getUserById(String id) async {
    try {
      final model = await _remoteDataSource.getUserById(id);
      if (model != null) {
        await _localDataSource.cacheUser(model);
        return UserMapper.toEntity(model);
      }
    } catch (_) {
      final cachedUsers = await _localDataSource.getCachedUsersByIds([id]);
      if (cachedUsers.isNotEmpty) {
        return UserMapper.toEntity(cachedUsers.first);
      }
    }

    return null;
  }

  @override
  Future<User> getUserProfile() async {
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
  Future<List<User>> searchUser(String search) async {
    final models = await _remoteDataSource.searchUser(search);

    return models.map(UserMapper.toEntity).toList();
  }

  @override
  Future<User> updateUserProfile(User user) {
    throw UnimplementedError();
  }
}
