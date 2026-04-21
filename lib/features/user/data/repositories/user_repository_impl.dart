import 'package:social_app/features/user/domain/entites/user.dart';
import 'package:social_app/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<User?> getUserById(String id) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<User> getUserProfile() {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }

  @override
  Future<List<User>> searchUser(String search) {
    // TODO: implement searchUser
    throw UnimplementedError();
  }

  @override
  Future<User> updateUserProfile(User user) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }
}
