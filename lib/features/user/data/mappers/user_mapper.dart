import '../../domain/entites/user_entity.dart';
import '../models/user_model.dart';

class UserMapper {
  const UserMapper._();

  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      username: model.username,
      email: model.email,
      avatarUrl: model.avatarUrl,
      bio: model.bio,
      friends: model.friends,
      following: model.following,
      followers: model.followers,
      isOnline: model.isOnline,
      lastSeen: model.lastSeen,
      createdAt: model.createdAt,
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
      friends: entity.friends,
      following: entity.following,
      followers: entity.followers,
      isOnline: entity.isOnline,
      lastSeen: entity.lastSeen,
      createdAt: entity.createdAt,
    );
  }
}
