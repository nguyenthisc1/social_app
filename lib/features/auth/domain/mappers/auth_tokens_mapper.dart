import '../../data/models/auth_tokens_model.dart';
import '../entities/auth_tokens.dart';

/// Mapper class to convert between AuthTokensModel and AuthTokens entity
class AuthTokensMapper {
  /// Convert AuthTokensModel to AuthTokens entity
  static AuthTokens fromModel(AuthTokensModel model) {
    return AuthTokens(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
      expiresAt: model.expiresAt,
    );
  }

  /// Convert AuthTokens entity to AuthTokensModel
  static AuthTokensModel toModel(AuthTokens entity) {
    return AuthTokensModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresAt: entity.expiresAt,
    );
  }
}

