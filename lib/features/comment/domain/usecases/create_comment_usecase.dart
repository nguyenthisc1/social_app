import 'package:social_app/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app/features/comment/domain/repositories/comment_repository.dart';

class CreateCommentUsecase {
  final CommentRepository repository;

  CreateCommentUsecase({required this.repository});

  Future<CommentEntity> call({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    return await repository.createComment(
      postId: postId,
      content: content,
      parentCommentId: parentCommentId,
    );
  }
}
