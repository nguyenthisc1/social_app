import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/features/auth/data/datasources/local/shared-preferences/auth_preferences_local_data_source.dart';
import 'package:social_app/features/auth/data/models/auth_tokens_model.dart';
import 'package:social_app/features/user/data/models/user_model.dart';

import '../../../fixtures/auth_fixtures.dart';

void main() {
  late SharedPreferences prefs;
  late AuthPreferencesLocalDataSource dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    dataSource = AuthPreferencesLocalDataSource(sharedPreferences: prefs);
  });

  test('Case 1: cacheUser -> getCachedUser', () async {
    await dataSource.cacheUser(fakeUserModel);

    final loadedUser = await dataSource.getCachedUser();

    expect(loadedUser, isA<UserModel>());
    expect(loadedUser!.id, fakeUserModel.id);
    expect(loadedUser.username, fakeUserModel.username);
    expect(loadedUser.email, fakeUserModel.email);
    expect(loadedUser.avatarUrl, fakeUserModel.avatarUrl);
    expect(loadedUser.bio, fakeUserModel.bio);
    expect(loadedUser.friends, fakeUserModel.friends);
    expect(loadedUser.followers, fakeUserModel.followers);
    expect(loadedUser.following, fakeUserModel.following);
    expect(loadedUser.isOnline, fakeUserModel.isOnline);
    expect(
      loadedUser.lastSeen.millisecondsSinceEpoch,
      fakeUserModel.lastSeen.millisecondsSinceEpoch,
    );
    expect(
      loadedUser.createdAt.millisecondsSinceEpoch,
      fakeUserModel.createdAt.millisecondsSinceEpoch,
    );
  });

  test('Case 2: cacheTokens -> getCachedTokens', () async {
    await dataSource.cacheTokens(fakeAuthTokensModel);

    final loadedTokens = await dataSource.getCachedTokens();

    expect(loadedTokens, isA<AuthTokensModel>());
    expect(loadedTokens!.accessToken, fakeAuthTokensModel.accessToken);
    expect(loadedTokens.refreshToken, fakeAuthTokensModel.refreshToken);
    expect(loadedTokens.tokenType, fakeAuthTokensModel.tokenType);
    expect(
      loadedTokens.expiresAt.millisecondsSinceEpoch,
      fakeAuthTokensModel.expiresAt.millisecondsSinceEpoch,
    );
  });

  test('Case 3: malformed user json response null', () async {
    await prefs.setString('CACHED_USER', '{not valid json}');
    final user = await dataSource.getCachedUser();
    expect(user, isNull);
  });

  test('Case 4: malformed tokens json response null', () async {
    await prefs.setString('CACHED_TOKENS', '{not valid json}');
    final tokens = await dataSource.getCachedTokens();
    expect(tokens, isNull);
  });

  // Case 5: clearAllData xóa cả user và token
  test('Case 5: clearAllData delete user and token', () async {
    await dataSource.cacheUser(fakeUserModel);
    await dataSource.cacheTokens(fakeAuthTokensModel);

    expect(await dataSource.getCachedUser(), isNotNull);
    expect(await dataSource.getCachedTokens(), isNotNull);

    await dataSource.clearAllData();

    expect(await dataSource.getCachedUser(), isNull);
    expect(await dataSource.getCachedTokens(), isNull);
  });
}
