import 'package:social_app/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app/features/comment/domain/value_objects/pagination_params.dart';

abstract class CommentRepository {
  Future<CommentEntity> createComment({
    required String postId,
    required String content,
    String? parentCommentId,
  });

  Future<CommentEntity> updateComment({
    required String commentId,
    required String content,
  });

  Future<void> deleteComment(String commentId);

  Future<List<CommentEntity>> getCommentsByPost({
    required String postId,
    required PaginationParams? query,
  });

  Future<List<CommentEntity>> getReplies({
    required String commentId,
    required PaginationParams? query,
  });
}
