import 'package:equatable/equatable.dart';

/// Model for authentication tokens with JSON serialization
class AuthTokensModel extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String tokenType;

  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.tokenType = 'Bearer',
  });

  /// Check if the token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if the token will expire soon (within 5 minutes)
  bool get willExpireSoon =>
      DateTime.now().add(const Duration(minutes: 5)).isAfter(expiresAt);

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt, tokenType];

  /// Create AuthTokensModel from JSON
  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : DateTime.now().add(const Duration(hours: 1)), // Default 1 hour
      tokenType: json['token_type'] as String? ?? 'Bearer',
    );
  }

  /// Convert AuthTokensModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
      'token_type': tokenType,
    };
  }

  /// Create a copy with updated fields
  AuthTokensModel copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? tokenType,
  }) {
    return AuthTokensModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      tokenType: tokenType ?? this.tokenType,
    );
  }
}
