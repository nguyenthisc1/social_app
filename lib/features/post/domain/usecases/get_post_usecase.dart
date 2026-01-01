import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/post/domain/entites/post_entity.dart';
import 'package:social_app/features/post/domain/repositories/post_repository.dart';

class GetPostUsecase {
  final PostRepository repository;
  GetPostUsecase({required this.repository});

  Future<Either<Failure, PostEntity>> call(String postId) async {
    return await repository.getPost(postId);
  }
}
