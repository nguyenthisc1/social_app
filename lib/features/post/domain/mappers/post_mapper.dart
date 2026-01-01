import 'package:social_app/features/post/data/models/post_model.dart';
import 'package:social_app/features/post/domain/entites/post_entity.dart';
import 'package:social_app/features/post/domain/entites/post_enum_extension.dart';

class PostMapper {
  static PostEntity fromModel(PostModel model) {
    return PostEntity(
      id: model.id,
      author: model.author,
      content: model.content,
      images: model.images,
      type: model.type.toPostType(),
      sharedPostId: model.sharedPostId,
      visibility: model.visibility.toPostVisibility(),
      allowedUserIds: model.allowedUserIds,
      likeCount: model.likeCount,
      commentCount: model.commentCount,
      status: model.status.toPostStatus(),
      isDeleted: model.isDeleted,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      v: model.v,
    );
  }

  static PostModel toModel(PostEntity entity) {
    return PostModel(
      id: entity.id,
      author: entity.author,
      content: entity.content,
      images: entity.images,
      type: entity.type.value,
      sharedPostId: entity.sharedPostId,
      visibility: entity.visibility.value,
      allowedUserIds: entity.allowedUserIds,
      likeCount: entity.likeCount,
      commentCount: entity.commentCount,
      status: entity.status.value,
      isDeleted: entity.isDeleted,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      v: entity.v,
    );
  }

  static List<PostEntity> fromModelList(List<PostModel> models) {
    return models.map((model) => fromModel(model)).toList();
  }

  static List<PostModel> toModelList(List<PostEntity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}
