import 'package:dartz/dartz.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app/features/comment/domain/repositories/comment_repository.dart';

class UpdateCommentUsecase {
  final CommentRepository repository;

  UpdateCommentUsecase({required this.repository});

  Future<Either<Failure, CommentEntity>> call({
    required String commentId,
    required String content,
  }) async {
    return await repository.updateComment(
      commentId: commentId,
      content: content,
    );
  }
}
