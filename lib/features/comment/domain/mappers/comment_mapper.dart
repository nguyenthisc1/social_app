import 'package:social_app/features/comment/data/models/comment_model.dart';
import 'package:social_app/features/comment/domain/entities/comment_entity.dart';

class CommentMapper {
  static CommentEntity fromModel(CommentModel model) {
    return CommentEntity(
      postId: model.postId,
      parentCommentId: model.parentCommentId,
      content: model.content,
      likeCount: model.likeCount,
      authorId: model.authorId,
      isDeleted: model.isDeleted,
      deletedAt: model.deletedAt,
      isEdited: model.isEdited,
    );
  }

  static CommentModel toModel(CommentEntity entity) {
    return CommentModel(
      postId: entity.postId,
      parentCommentId: entity.parentCommentId,
      content: entity.content,
      likeCount: entity.likeCount,
      authorId: entity.authorId,
      isDeleted: entity.isDeleted,
      deletedAt: entity.deletedAt,
      isEdited: entity.isEdited,
    );
  }

  static List<CommentEntity> fromModelList(List<CommentModel> models) {
    return models.map((model) => fromModel(model)).toList();
  }

  static List<CommentModel> toModelList(List<CommentEntity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}
