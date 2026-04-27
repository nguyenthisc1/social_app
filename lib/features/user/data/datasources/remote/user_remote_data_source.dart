import 'package:social_app/features/user/data/models/user_model.dart';

abstract interface class UserRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile(UserModel user);
  Future<List<UserModel>> searchUser(String search);
  Future<UserModel?> getUserById(String id);
  Future<List<UserModel>> getUsersByIds(List<String> ids);
}
