import 'package:social_app/features/post/domain/entities/post_entity.dart';
import 'package:social_app/features/post/domain/entities/post_enum.dart';

abstract interface class PostRepository {
  Future<PostEntity> createPost({
    required String content,
    required PostVisibility visibility,
    required PostType type,
  });

  Future<PostEntity> updatePost({
    required String postId,
    required String content,
    required PostVisibility visibility,
    required PostType type,
  });

  Future<void> deletePost(String postId);

  Future<PostEntity> getPost(String postId);

  Future<List<PostEntity>> getHomePost();

  Future<List<PostEntity>> getPostsByUser(String viewerId);
}
