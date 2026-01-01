import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/post/domain/entites/post_entity.dart';
import 'package:social_app/features/post/domain/entites/post_enum.dart';

abstract class PostRepository {
  Future<Either<Failure, PostEntity>> createPost({
    required String content,
    required PostVisibility visibility,
    required PostType type,
  });

  Future<Either<Failure, PostEntity>> updatePost({
    required String postId,
    required String content,
    required PostVisibility visibility,
    required PostType type,
  });

  Future<Either<Failure, void>> deletePost(String postId);

  Future<Either<Failure, PostEntity>> getPost(String postId);

  Future<Either<Failure, List<PostEntity>>> getHomePost();

  Future<Either<Failure, List<PostEntity>>> getPostsByUser(String viewerId);
}
