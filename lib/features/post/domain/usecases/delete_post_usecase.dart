import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/post/domain/repositories/post_repository.dart';

class DeletePostUsecase {
  final PostRepository repository;
  DeletePostUsecase(this.repository);

  Future<Either<Failure, void>> call(String postId) async {
    return await repository.deletePost(postId);
  }
}
