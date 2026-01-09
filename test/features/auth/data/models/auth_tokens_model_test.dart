import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:social_app/features/auth/data/models/auth_tokens_model.dart';
import 'package:social_app/features/auth/domain/entities/auth_tokens.dart';
import 'package:social_app/features/auth/domain/mappers/auth_tokens_mapper.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tAuthTokensModel = AuthTokensModel(
    accessToken: 'test_access_token_123',
    refreshToken: 'test_refresh_token_456',
    expiresAt: DateTime.parse('2024-12-31T23:59:59.000Z'),
    tokenType: 'Bearer',
  );

  group('AuthTokensModel', () {
    test('should be a subclass of Equatable', () {
      expect(tAuthTokensModel, isA<AuthTokensModel>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('auth/auth_tokens.json'));

        // act
        final result = AuthTokensModel.fromJson(jsonMap);

        // assert
        expect(result, tAuthTokensModel);
      });

      test('should use default expiry when expires_at is null', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'access_token': 'test_access_token',
          'refresh_token': 'test_refresh_token',
        };

        // act
        final result = AuthTokensModel.fromJson(jsonMap);

        // assert
        expect(result.accessToken, 'test_access_token');
        expect(result.refreshToken, 'test_refresh_token');
        expect(result.expiresAt.isAfter(DateTime.now()), true);
      });

      test('should use default token type when not provided', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'access_token': 'test_access_token',
          'refresh_token': 'test_refresh_token',
          'expires_at': '2024-12-31T23:59:59.000Z',
        };

        // act
        final result = AuthTokensModel.fromJson(jsonMap);

        // assert
        expect(result.tokenType, 'Bearer');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tAuthTokensModel.toJson();

        // assert
        final expectedMap = {
          'access_token': 'test_access_token_123',
          'refresh_token': 'test_refresh_token_456',
          'expires_at': '2024-12-31T23:59:59.000Z',
          'token_type': 'Bearer',
        };
        expect(result, expectedMap);
      });
    });

    group('isExpired', () {
      test('should return false when token is not expired', () {
        final futureExpiry = DateTime.now().add(const Duration(hours: 1));
        final tokens = AuthTokensModel(
          accessToken: 'test',
          refreshToken: 'test',
          expiresAt: futureExpiry,
        );

        expect(tokens.isExpired, false);
      });

      test('should return true when token is expired', () {
        final pastExpiry = DateTime.now().subtract(const Duration(hours: 1));
        final tokens = AuthTokensModel(
          accessToken: 'test',
          refreshToken: 'test',
          expiresAt: pastExpiry,
        );

        expect(tokens.isExpired, true);
      });
    });

    group('willExpireSoon', () {
      test('should return false when token has more than 5 minutes', () {
        final futureExpiry = DateTime.now().add(const Duration(minutes: 10));
        final tokens = AuthTokensModel(
          accessToken: 'test',
          refreshToken: 'test',
          expiresAt: futureExpiry,
        );

        expect(tokens.willExpireSoon, false);
      });

      test('should return true when token expires within 5 minutes', () {
        final soonExpiry = DateTime.now().add(const Duration(minutes: 3));
        final tokens = AuthTokensModel(
          accessToken: 'test',
          refreshToken: 'test',
          expiresAt: soonExpiry,
        );

        expect(tokens.willExpireSoon, true);
      });
    });

    group('copyWith', () {
      test('should return new instance with updated values', () {
        // act
        final result = tAuthTokensModel.copyWith(
          accessToken: 'new_access_token',
        );

        // assert
        expect(result.accessToken, 'new_access_token');
        expect(result.refreshToken, tAuthTokensModel.refreshToken);
        expect(result.expiresAt, tAuthTokensModel.expiresAt);
      });
    });
  });

  group('AuthTokensMapper', () {
    test('should convert AuthTokensModel to AuthTokens entity', () {
      // act
      final result = AuthTokensMapper.fromModel(tAuthTokensModel);

      // assert
      expect(result, isA<AuthTokens>());
      expect(result.accessToken, tAuthTokensModel.accessToken);
      expect(result.refreshToken, tAuthTokensModel.refreshToken);
      expect(result.expiresAt, tAuthTokensModel.expiresAt);
    });

    test('should convert AuthTokens entity to AuthTokensModel', () {
      // arrange
      final tAuthTokens = AuthTokens(
        accessToken: 'test_access',
        refreshToken: 'test_refresh',
        expiresAt: DateTime.parse('2024-12-31T23:59:59.000Z'),
      );

      // act
      final result = AuthTokensMapper.toModel(tAuthTokens);

      // assert
      expect(result, isA<AuthTokensModel>());
      expect(result.accessToken, tAuthTokens.accessToken);
      expect(result.refreshToken, tAuthTokens.refreshToken);
    });
  });
}

