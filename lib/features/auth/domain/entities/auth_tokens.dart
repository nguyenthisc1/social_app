import 'package:equatable/equatable.dart';

/// Authentication tokens
class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  /// Check if access token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if token is about to expire (within 5 minutes)
  bool get isAboutToExpire {
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(expiresAt);
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt];
}

