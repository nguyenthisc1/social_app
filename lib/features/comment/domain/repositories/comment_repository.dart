import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/core/entities/pagination_param.dart';
import 'package:social_app/features/comment/domain/entities/comment_entity.dart';

abstract class CommentRepository {
  Future<Either<Failure, CommentEntity>> createComment({
    required String postId,
    required String content,
    String? parentCommentId,
  });

  Future<Either<Failure, CommentEntity>> updateComment({
    required String commentId,
    required String content,
  });

  Future<Either<Failure, void>> deleteComment(String commentId);

  Future<Either<Failure, List<CommentEntity>>> getCommentsByPost({
    required String postId,
    required PaginationParams? query,
  });

  Future<Either<Failure, List<CommentEntity>>> getReplies({
    required String commentId,
    required PaginationParams? query,
  });
}
