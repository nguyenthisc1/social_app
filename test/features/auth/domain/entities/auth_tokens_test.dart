import 'package:flutter_test/flutter_test.dart';
import 'package:social_app/features/auth/domain/entities/auth_tokens.dart';

void main() {
  group('AuthTokens Entity', () {
    final tExpiresAt = DateTime.now().add(const Duration(hours: 1));
    final tAuthTokens = AuthTokens(
      accessToken: 'test_access_token',
      refreshToken: 'test_refresh_token',
      expiresAt: tExpiresAt,
    );

    test('should be a subclass of Equatable', () {
      expect(tAuthTokens, isA<AuthTokens>());
    });

    test('should support value equality', () {
      final tAuthTokens2 = AuthTokens(
        accessToken: 'test_access_token',
        refreshToken: 'test_refresh_token',
        expiresAt: tExpiresAt,
      );

      expect(tAuthTokens, equals(tAuthTokens2));
    });

    test('isExpired should return false when token is not expired', () {
      final futureExpiry = DateTime.now().add(const Duration(hours: 1));
      final tokens = AuthTokens(
        accessToken: 'test',
        refreshToken: 'test',
        expiresAt: futureExpiry,
      );

      expect(tokens.isExpired, false);
    });

    test('isExpired should return true when token is expired', () {
      final pastExpiry = DateTime.now().subtract(const Duration(hours: 1));
      final tokens = AuthTokens(
        accessToken: 'test',
        refreshToken: 'test',
        expiresAt: pastExpiry,
      );

      expect(tokens.isExpired, true);
    });

    test('isAboutToExpire should return false when token has more than 5 minutes', () {
      final futureExpiry = DateTime.now().add(const Duration(minutes: 10));
      final tokens = AuthTokens(
        accessToken: 'test',
        refreshToken: 'test',
        expiresAt: futureExpiry,
      );

      expect(tokens.isAboutToExpire, false);
    });

    test('isAboutToExpire should return true when token expires within 5 minutes', () {
      final soonExpiry = DateTime.now().add(const Duration(minutes: 3));
      final tokens = AuthTokens(
        accessToken: 'test',
        refreshToken: 'test',
        expiresAt: soonExpiry,
      );

      expect(tokens.isAboutToExpire, true);
    });
  });
}

