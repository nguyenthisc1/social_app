import 'package:social_app/features/user/domain/entites/user.dart';

abstract interface class UserRepository {
  Future<User> getUserProfile();
  Future<User> updateUserProfile(User user);
  Future<List<User>> searchUser(String search);
  Future<User?> getUserById(String id);
}
