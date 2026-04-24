import 'package:social_app/features/user/data/models/user_model.dart';

abstract interface class UserLocalDataSource {
  Future<void> cacheUser(UserModel user);

  Future<UserModel?> getCachedUser();

  Future<List<UserModel>> getCachedUsersByIds(List<String> ids);

  Future<void> clearCachedUser();
}
