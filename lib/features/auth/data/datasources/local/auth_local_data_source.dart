import '../../../../user/data/models/user_model.dart';
import '../../models/auth_tokens_model.dart';

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
