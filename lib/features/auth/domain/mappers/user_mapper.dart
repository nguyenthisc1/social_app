import '../../data/models/user_model.dart';
import '../entities/user.dart';

/// Mapper class to convert between UserModel and User entity
class UserMapper {
  /// Convert UserModel to User entity
  static User fromModel(UserModel model) {
    return User(
      id: model.id,
      email: model.email,
      username: model.username,
      displayName: model.displayName,
      bio: model.bio,
      avatarUrl: model.avatarUrl,
      coverImageUrl: model.coverImageUrl,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      followersCount: model.followersCount,
      followingCount: model.followingCount,
      postsCount: model.postsCount,
      isVerified: model.isVerified,
      isPrivate: model.isPrivate,
    );
  }

  /// Convert User entity to UserModel
  static UserModel toModel(User entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      displayName: entity.displayName,
      bio: entity.bio,
      avatarUrl: entity.avatarUrl,
      coverImageUrl: entity.coverImageUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      followersCount: entity.followersCount,
      followingCount: entity.followingCount,
      postsCount: entity.postsCount,
      isVerified: entity.isVerified,
      isPrivate: entity.isPrivate,
    );
  }

  /// Convert list of UserModels to list of User entities
  static List<User> fromModelList(List<UserModel> models) {
    return models.map((model) => fromModel(model)).toList();
  }

  /// Convert list of User entities to list of UserModels
  static List<UserModel> toModelList(List<User> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}

