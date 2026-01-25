import 'package:social_app/features/friendship/data/models/friendship_model.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';

/// Mapper for converting between Friendship models and entities
class FriendshipMapper {
  FriendshipMapper._();

  /// Convert FriendshipModel to FriendshipEntity
  static FriendshipEntity toEntity(FriendshipModel model) {
    return FriendshipEntity(
      id: model.id,
      requesterId: model.requesterId,
      receiverId: model.receiverId,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert FriendRequestModel to FriendRequestEntity
  static FriendRequestEntity toRequestEntity(FriendRequestModel model) {
    return FriendRequestEntity(
      id: model.id,
      requesterId: model.requesterId,
      receiverId: model.receiverId,
      status: model.status,
      username: model.username,
      email: model.email,
      avatarUrl: model.avatarUrl,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert FriendshipResponseModel to FriendshipResponseEntity
  static FriendshipResponseEntity toResponseEntity(
    FriendshipResponseModel model,
  ) {
    return FriendshipResponseEntity(
      success: model.success,
      message: model.message,
    );
  }

  /// Convert FriendModel to FriendEntity
  static FriendEntity toFriendEntity(FriendModel model) {
    return FriendEntity(
      id: model.id,
      username: model.username,
      email: model.email,
      avatarUrl: model.avatarUrl,
      bio: model.bio,
    );
  }

  /// Convert FriendshipStatusModel to FriendshipStatusEntity
  static FriendshipStatusEntity toStatusEntity(FriendshipStatusModel model) {
    return FriendshipStatusEntity(
      isFriend: model.isFriend,
      message: model.message,
    );
  }

  /// Convert list of FriendshipModel to list of FriendshipEntity
  static List<FriendshipEntity> toEntityList(List<FriendshipModel> models) {
    return models.map(toEntity).toList();
  }

  /// Convert list of FriendRequestModel to list of FriendRequestEntity
  static List<FriendRequestEntity> toRequestEntityList(
    List<FriendRequestModel> models,
  ) {
    return models.map(toRequestEntity).toList();
  }

  /// Convert list of FriendModel to list of FriendEntity
  static List<FriendEntity> toFriendEntityList(List<FriendModel> models) {
    return models.map(toFriendEntity).toList();
  }
}
