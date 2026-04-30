import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:social_app/features/auth/domain/auth_exceptions.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../fixtures/auth_fixtures.dart';

void main() {
  late MockAuthFirebaseRemoteDataSource mockRemote;
  late MockAuthLocalDataSource mockLocal;
  late MockNetworkInfo mockNetwork;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemote = MockAuthFirebaseRemoteDataSource();
    mockLocal = MockAuthLocalDataSource();
    mockNetwork = MockNetworkInfo();

    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  group('login', () {
    test(
      'Case 1: offline (Not connecting internet) => throw NetworkException',
      () async {
        when(mockNetwork.isConnected).thenAnswer((_) async => false);

        expect(
          () => repository.login(email: 'test@mail.com', password: '123456'),
          throwsA(isA<NetworkException>()),
        );
      },
    );

    test(
      'Case 2: online + remote login success => cacheUser, cacheTokens, return UserEntity',
      () async {
        when(mockNetwork.isConnected).thenAnswer((_) async => true);
        when(
          mockRemote.login(email: 'test@mail.com', password: '123456'),
        ).thenAnswer((_) async => fakeLoginResponseMap);

        final result = await repository.login(
          email: 'test@mail.com',
          password: '123456',
        );

        verify(mockLocal.cacheUser(any)).called(1);
        verify(mockLocal.cacheTokens(any)).called(1);
        expect(result.id, fakeUserEntity.id);
      },
    );

    test(
      'Case 3: online + remote login throws exception => bubble/map implementation real',
      () async {
        when(mockNetwork.isConnected).thenAnswer((_) async => true);
        when(
          mockRemote.login(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(ServerException());

        expect(
          () => repository.login(email: 'test@mail.com', password: '123456'),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('register', () {
    test(
      'Case 1: offline (Not connecting internet) => throw NetworkException',
      () async {
        when(mockNetwork.isConnected).thenAnswer((_) async => false);

        expect(
          () => repository.register(
            email: 'test@mail.com',
            username: 'Test User',
            password: '123456',
          ),
          throwsA(isA<NetworkException>()),
        );
      },
    );

    test(
      'Case 2: online + remote register success => cacheUser, cacheTokens, return UserEntity',
      () async {
        when(mockNetwork.isConnected).thenAnswer((_) async => true);
        when(
          mockRemote.register(
            email: 'test@mail.com',
            username: 'Test User',
            password: '123456',
          ),
        ).thenAnswer((_) async => fakeLoginResponseMap);

        final result = await repository.register(
          email: 'test@mail.com',
          username: 'Test User',
          password: '123456',
        );

        verify(mockLocal.cacheUser(any)).called(1);
        verify(mockLocal.cacheTokens(any)).called(1);
        expect(result.id, fakeUserEntity.id);
      },
    );
  });

  group('logout', () {
    test(
      'Case 1: online, with tokens and cached user => calls remote.logout(user.id) and clear local data',
      () async {
        when(mockNetwork.isConnected).thenAnswer((_) async => true);
        when(
          mockLocal.getCachedTokens(),
        ).thenAnswer((_) async => fakeAuthTokensModel);
        when(mockLocal.getCachedUser()).thenAnswer((_) async => fakeUserModel);
        when(mockRemote.logout(fakeUserEntity.id)).thenAnswer((_) async => {});
        when(mockLocal.clearAllData()).thenAnswer((_) async {});

        await repository.logout();

        verify(mockRemote.logout(fakeUserEntity.id)).called(1);
        verify(mockLocal.clearAllData()).called(1);
      },
    );

    test(
      'Case 2: offline => does not call remote.logout, still clears local data',
      () async {
        when(mockNetwork.isConnected).thenAnswer((_) async => false);
        when(mockLocal.getCachedTokens()).thenAnswer((_) async => null);
        when(mockLocal.getCachedUser()).thenAnswer((_) async => null);
        when(mockLocal.clearAllData()).thenAnswer((_) async {});

        await repository.logout();

        verifyNever(mockRemote.logout(any));
        verify(mockLocal.clearAllData()).called(1);
      },
    );

    test('Case 3: local clear fails => throws CacheException', () async {
      when(mockNetwork.isConnected).thenAnswer((_) async => true);
      when(
        mockLocal.getCachedTokens(),
      ).thenAnswer((_) async => fakeAuthTokensModel);
      when(mockLocal.getCachedUser()).thenAnswer((_) async => fakeUserModel);
      when(mockRemote.logout(fakeUserEntity.id)).thenAnswer((_) async => {});
      when(mockLocal.clearAllData()).thenThrow(Exception('cache clear failed'));

      expect(() => repository.logout(), throwsA(isA<CacheException>()));
    });
  });

  group('getCurrentUser', () {
    test('Case 1: Have cached user, offline => return cached user', () async {
      when(mockLocal.getCachedUser()).thenAnswer((_) async => fakeUserModel);
      when(mockNetwork.isConnected).thenAnswer((_) async => false);

      final result = await repository.getCurrentUser();

      expect(result.id, fakeUserEntity.id);
    });

    test(
      'Case 2: Have cached user, online, token access, remote success => fetch remote, update cache, return remote user',
      () async {
        when(mockLocal.getCachedUser()).thenAnswer((_) async => fakeUserModel);
        when(mockNetwork.isConnected).thenAnswer((_) async => true);
        when(
          mockLocal.getCachedTokens(),
        ).thenAnswer((_) async => fakeAuthTokensModel);

        when(
          mockRemote.getCurrentUser(
            accessToken: fakeAuthTokensModel.accessToken,
          ),
        ).thenAnswer((_) async => fakeUserModel);

        when(mockLocal.cacheUser(any)).thenAnswer((_) async {});

        final result = await repository.getCurrentUser();

        verify(
          mockRemote.getCurrentUser(
            accessToken: fakeAuthTokensModel.accessToken,
          ),
        ).called(1);
        verify(mockLocal.cacheUser(any)).called(1);
        expect(result.id, fakeUserEntity.id);
      },
    );

    test(
      'Case 3: Have cached user, online, remote fail => fallback cached user',
      () async {
        when(mockLocal.getCachedUser()).thenAnswer((_) async => fakeUserModel);
        when(mockNetwork.isConnected).thenAnswer((_) async => true);
        when(
          mockLocal.getCachedTokens(),
        ).thenAnswer((_) async => fakeAuthTokensModel);

        when(
          mockRemote.getCurrentUser(
            accessToken: fakeAuthTokensModel.accessToken,
          ),
        ).thenThrow(ServerException());

        final result = await repository.getCurrentUser();

        expect(result.id, fakeUserEntity.id);
      },
    );

    test(
      'Case 4: Dont have cached user, offline => throw NetworkException',
      () async {
        when(mockLocal.getCachedUser()).thenAnswer((_) async => null);
        when(mockNetwork.isConnected).thenAnswer((_) async => false);

        expect(
          () => repository.getCurrentUser(),
          throwsA(isA<NetworkException>()),
        );
      },
    );

    test(
      'Case 5: Dont have cached user, online, token access, remote success => fetch remote, cache user, return user',
      () async {
        when(mockLocal.getCachedUser()).thenAnswer((_) async => null);
        when(mockNetwork.isConnected).thenAnswer((_) async => true);
        when(
          mockLocal.getCachedTokens(),
        ).thenAnswer((_) async => fakeValidAuthTokensModel);

        when(
          mockRemote.getCurrentUser(
            accessToken: fakeValidAuthTokensModel.accessToken,
          ),
        ).thenAnswer((_) async => fakeUserModel);

        when(mockLocal.cacheUser(any)).thenAnswer((_) async {});

        final result = await repository.getCurrentUser();

        verify(
          mockRemote.getCurrentUser(
            accessToken: fakeValidAuthTokensModel.accessToken,
          ),
        ).called(1);
        verify(mockLocal.cacheUser(any)).called(1);
        expect(result.id, fakeUserEntity.id);
      },
    );
  });

  group('refreshToken', () {
    test('Case 1: offline => throw NetworkException', () async {
      when(mockNetwork.isConnected).thenAnswer((_) async => false);

      expect(() => repository.refreshToken(), throwsA(isA<NetworkException>()));
    });

    test(
      'Case 2: online, dont have cached tokens => throw AuthTokenException',
      () async {
        when(mockNetwork.isConnected).thenAnswer((_) async => true);
        when(mockLocal.getCachedTokens()).thenAnswer((_) async => null);

        expect(
          () => repository.refreshToken(),
          throwsA(isA<AuthTokenException>()),
        );
      },
    );

    test(
      'Case 3: online, have refresh token, remote success => cache new token, return token entity',
      () async {
        when(mockNetwork.isConnected).thenAnswer((_) async => true);
        when(
          mockLocal.getCachedTokens(),
        ).thenAnswer((_) async => fakeExpiredAuthTokensModel);
        when(
          mockRemote.refreshToken(
            refreshToken: fakeExpiredAuthTokensModel.refreshToken,
          ),
        ).thenAnswer((_) async => fakeLoginResponseMap);
        when(mockLocal.cacheTokens(any)).thenAnswer((_) async {});

        final result = await repository.refreshToken();

        verify(
          mockRemote.refreshToken(
            refreshToken: fakeExpiredAuthTokensModel.refreshToken,
          ),
        ).called(1);
        verify(mockLocal.cacheTokens(any)).called(1);
        expect(result.accessToken, fakeAuthTokensModel.accessToken);
      },
    );

    test('Case 4: remote refresh fail => throw exception branch', () async {
      when(mockNetwork.isConnected).thenAnswer((_) async => true);
      when(
        mockLocal.getCachedTokens(),
      ).thenAnswer((_) async => fakeExpiredAuthTokensModel);
      when(
        mockRemote.refreshToken(
          refreshToken: fakeExpiredAuthTokensModel.refreshToken,
        ),
      ).thenThrow(ServerException());

      expect(() => repository.refreshToken(), throwsA(isA<ServerException>()));
    });
  });

  group('isAuthenticated', () {
    test(
      'Case 1: Dont have cached tokens, if isAuthenticated => false',
      () async {
        when(mockLocal.getCachedTokens()).thenAnswer((_) async => null);

        final result = await repository.isAuthenticated();

        expect(result, false);
      },
    );

    test('Case 2: token not yet expired, if isAuthenticated => true', () async {
      when(
        mockLocal.getCachedTokens(),
      ).thenAnswer((_) async => fakeValidAuthTokensModel);

      final result = await repository.isAuthenticated();

      expect(result, true);
    });

    test(
      'Case 3: token expired, refresh success, if isAuthenticated => true',
      () async {
        when(
          mockLocal.getCachedTokens(),
        ).thenAnswer((_) async => fakeExpiredAuthTokensModel);
        when(
          mockRemote.refreshToken(refreshToken: anyNamed('refreshToken')),
        ).thenAnswer((_) async => fakeLoginResponseMap);
        when(mockLocal.cacheTokens(any)).thenAnswer((_) async {});

        final result = await repository.isAuthenticated();

        expect(result, true);
      },
    );

    test(
      'Case 4: token expried, refresh fail, if isAuthenticated => false',
      () async {
        when(
          mockLocal.getCachedTokens(),
        ).thenAnswer((_) async => fakeExpiredAuthTokensModel);
        when(
          mockRemote.refreshToken(refreshToken: anyNamed('refreshToken')),
        ).thenThrow(NetworkException());

        final result = await repository.isAuthenticated();

        expect(result, false);
      },
    );
  });
}
