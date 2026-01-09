import '../../data/models/user_model.dart';
import '../entities/user.dart';

/// Mapper class to convert between UserModel and User entity
class UserMapper {
  /// Convert UserModel to User entity
  static User fromModel(UserModel model) {
    return User(
      id: model.id,
      username: model.username,
      email: model.email,
      avatarUrl: model.avatarUrl,
      bio: model.bio,
      friends: model.friends,
      following: model.following,
      followers: model.followers,
      isActive: model.isActive,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert User entity to UserModel
  static UserModel toModel(User entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
      friends: entity.friends,
      following: entity.following,
      followers: entity.followers,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
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
