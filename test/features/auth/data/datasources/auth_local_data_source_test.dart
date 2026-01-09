import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:social_app/features/auth/data/models/auth_tokens_model.dart';
import 'package:social_app/features/auth/data/models/user_model.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late AuthLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AuthLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('cacheUser', () {
    final tUserModel = UserModel(
      id: 'user123',
      email: 'test@example.com',
      username: 'testuser',
      createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      updatedAt: DateTime.now(),
    );

    test('should call SharedPreferences to cache user', () async {
      // arrange
      when(
        mockSharedPreferences.setString(any, any),
      ).thenAnswer((_) async => true);

      // act
      await dataSource.cacheUser(tUserModel);

      // assert
      final expectedJsonString = json.encode(tUserModel.toJson());
      verify(
        mockSharedPreferences.setString('CACHED_USER', expectedJsonString),
      );
    });
  });

  group('getCachedUser', () {
    final tUserModel = UserModel(
      id: 'user123',
      email: 'test@example.com',
      username: 'testuser',
      createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      updatedAt: DateTime.now(),
    );

    test(
      'should return UserModel from SharedPreferences when present',
      () async {
        // arrange
        final jsonString = json.encode(tUserModel.toJson());
        when(mockSharedPreferences.getString(any)).thenReturn(jsonString);

        // act
        final result = await dataSource.getCachedUser();

        // assert
        verify(mockSharedPreferences.getString('CACHED_USER'));
        expect(result, equals(tUserModel));
      },
    );

    test('should return null when no cached user exists', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final result = await dataSource.getCachedUser();

      // assert
      verify(mockSharedPreferences.getString('CACHED_USER'));
      expect(result, null);
    });

    test('should return null when cached data is invalid', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn('invalid json');

      // act
      final result = await dataSource.getCachedUser();

      // assert
      expect(result, null);
    });
  });

  group('cacheTokens', () {
    final tTokensModel = AuthTokensModel(
      accessToken: 'test_access',
      refreshToken: 'test_refresh',
      expiresAt: DateTime.parse('2024-12-31T23:59:59.000Z'),
    );

    test('should call SharedPreferences to cache tokens', () async {
      // arrange
      when(
        mockSharedPreferences.setString(any, any),
      ).thenAnswer((_) async => true);

      // act
      await dataSource.cacheTokens(tTokensModel);

      // assert
      final expectedJsonString = json.encode(tTokensModel.toJson());
      verify(
        mockSharedPreferences.setString('CACHED_TOKENS', expectedJsonString),
      );
    });
  });

  group('getCachedTokens', () {
    final tTokensModel = AuthTokensModel(
      accessToken: 'test_access',
      refreshToken: 'test_refresh',
      expiresAt: DateTime.parse('2024-12-31T23:59:59.000Z'),
    );

    test(
      'should return AuthTokensModel from SharedPreferences when present',
      () async {
        // arrange
        final jsonString = json.encode(tTokensModel.toJson());
        when(mockSharedPreferences.getString(any)).thenReturn(jsonString);

        // act
        final result = await dataSource.getCachedTokens();

        // assert
        verify(mockSharedPreferences.getString('CACHED_TOKENS'));
        expect(result, equals(tTokensModel));
      },
    );

    test('should return null when no cached tokens exist', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final result = await dataSource.getCachedTokens();

      // assert
      expect(result, null);
    });
  });

  group('clearCachedUser', () {
    test('should call SharedPreferences to remove user', () async {
      // arrange
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

      // act
      await dataSource.clearCachedUser();

      // assert
      verify(mockSharedPreferences.remove('CACHED_USER'));
    });
  });

  group('clearCachedTokens', () {
    test('should call SharedPreferences to remove tokens', () async {
      // arrange
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

      // act
      await dataSource.clearCachedTokens();

      // assert
      verify(mockSharedPreferences.remove('CACHED_TOKENS'));
    });
  });

  group('clearAllData', () {
    test('should clear both user and tokens', () async {
      // arrange
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

      // act
      await dataSource.clearAllData();

      // assert
      verify(mockSharedPreferences.remove('CACHED_USER'));
      verify(mockSharedPreferences.remove('CACHED_TOKENS'));
    });
  });
}
