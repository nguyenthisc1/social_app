import 'package:dartz/dartz.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/comment/domain/repositories/comment_repository.dart';

class DeleteCommentUsecase {
  final CommentRepository repository;

  DeleteCommentUsecase({required this.repository});

  Future<Either<Failure, void>> call({required String commentId}) async {
    return await repository.deleteComment(commentId);
  }
}
