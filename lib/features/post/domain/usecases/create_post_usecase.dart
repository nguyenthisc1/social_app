import 'package:social_app/features/post/domain/entities/post_entity.dart';
import 'package:social_app/features/post/domain/entities/post_enum.dart';
import 'package:social_app/features/post/domain/repositories/post_repository.dart';

class CreatePostUsecase {
  final PostRepository repository;
  CreatePostUsecase(this.repository);

  Future<PostEntity> call({
    required String content,
    required PostVisibility visibility,
    required PostType type,
  }) async {
    return await repository.createPost(
      content: content,
      visibility: visibility,
      type: type,
    );
  }
}
