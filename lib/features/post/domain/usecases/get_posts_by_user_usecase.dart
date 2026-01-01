import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/post/domain/entites/post_entity.dart';
import 'package:social_app/features/post/domain/repositories/post_repository.dart';

class GetPostsByUserUsecase {
  final PostRepository repository;
  GetPostsByUserUsecase({required this.repository});

  Future<Either<Failure, List<PostEntity>>> call(String viewerId) async {
    return await repository.getPostsByUser(viewerId);
  }
}
