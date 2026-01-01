import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/post/domain/entites/post_entity.dart';
import 'package:social_app/features/post/domain/entites/post_enum.dart';
import 'package:social_app/features/post/domain/repositories/post_repository.dart';

class UpdatePostUsecase {
  final PostRepository repository;
  UpdatePostUsecase({required this.repository});

  Future<Either<Failure, PostEntity>> call({
    required String postId,
    required String content,
    required PostVisibility visibility,
    required PostType type,
  }) async {
    return await repository.updatePost(
      postId: postId,
      content: content,
      visibility: visibility,
      type: type,
    );
  }
}
