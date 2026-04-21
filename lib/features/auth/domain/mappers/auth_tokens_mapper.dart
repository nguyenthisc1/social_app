import '../../data/models/auth_tokens_model.dart';
import '../entities/auth_tokens.dart';

class AuthTokensMapper {
  static AuthTokens fromModel(AuthTokensModel model) {
    return AuthTokens(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
      expiresAt: model.expiresAt,
    );
  }

  static AuthTokensModel toModel(AuthTokens entity) {
    return AuthTokensModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresAt: entity.expiresAt,
    );
  }
}

