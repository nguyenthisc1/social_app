import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app/features/comment/domain/repositories/comment_repository.dart';
import 'package:social_app/features/comment/domain/value_objects/pagination_params.dart';

class GetCommentsByPostUsecase {
  final CommentRepository repository;

  GetCommentsByPostUsecase({required this.repository});

  Future<Either<Failure, List<CommentEntity>>> call({
    required String commentId,
    PaginationParams? query,
  }) async {
    return await repository.getReplies(commentId: commentId, query: query);
  }
}
