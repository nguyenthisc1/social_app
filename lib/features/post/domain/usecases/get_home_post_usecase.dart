import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/post/domain/entities/post_entity.dart';
import 'package:social_app/features/post/domain/repositories/post_repository.dart';

class GetHomePostUsecase {
  final PostRepository repository;
  GetHomePostUsecase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call() async {
    return await repository.getHomePost();
  }
}
