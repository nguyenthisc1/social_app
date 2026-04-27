import 'package:social_app/features/user/domain/entites/user_entity.dart';

abstract interface class UserRepository {
  Future<UserEntity> getUserProfile();
  Future<UserEntity> updateUserProfile(UserEntity user);
  Future<List<UserEntity>> searchUser(String search);
  Future<UserEntity?> getUserById(String id);
  Future<List<UserEntity>> getUsersByIds(List<String> ids);
}
