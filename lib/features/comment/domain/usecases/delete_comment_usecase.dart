import 'package:social_app/features/comment/domain/repositories/comment_repository.dart';

class DeleteCommentUsecase {
  final CommentRepository repository;

  DeleteCommentUsecase({required this.repository});

  Future<void> call({required String commentId}) async {
    return await repository.deleteComment(commentId);
  }
}
