import '../../../user/data/models/user_model.dart';
import '../../../user/domain/entites/user.dart';

class UserMapper {
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
    );
  }

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
    );
  }

  static List<User> fromModelList(List<UserModel> models) {
    return models.map((model) => fromModel(model)).toList();
  }

  static List<UserModel> toModelList(List<User> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}
