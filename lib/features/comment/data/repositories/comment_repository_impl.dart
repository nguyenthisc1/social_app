import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/core/network/base_response.dart';
import 'package:social_app/features/comment/data/datasources/comment_remote_data_source.dart';
import 'package:social_app/features/comment/data/models/comment_model.dart';
import 'package:social_app/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app/features/comment/domain/mappers/comment_mapper.dart';
import 'package:social_app/features/comment/domain/repositories/comment_repository.dart';
import 'package:social_app/features/comment/domain/value_objects/pagination_params.dart';

class CommentRepositoryImpl extends CommentRepository {
  final CommentRemoteDataSource remote;
  final NetworkInfo networkInfo;

  CommentRepositoryImpl({required this.remote, required this.networkInfo});

  @override
  Future<Either<Failure, CommentEntity>> createComment({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final BaseResponse<CommentModel> response = await remote.createComment(
        postId: postId,
        content: content,
        parentCommentId: parentCommentId,
      );

      final commentModel = response.data;

      if (commentModel == null) {
        return Left(
          ServerFailure(message: 'Comment creation failed: no data returned'),
        );
      }

      return Right(CommentMapper.fromModel(commentModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> updateComment({
    required String commentId,
    required String content,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final BaseResponse<CommentModel> response = await remote.updateComment(
        commentId: commentId,
        content: content,
      );
      final commentModel = response.data;

      if (commentModel == null) {
        return Left(
          ServerFailure(message: 'Comment update failed: no data returned'),
        );
      }

      return Right(CommentMapper.fromModel(commentModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remote.deleteComment(commentId);
      // ignore: void_checks
      return const Right(true);
    } on Exception catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getCommentsByPost({
    required String postId,
    required PaginationParams? query,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final BaseResponse<List<CommentModel>> response = await remote
          .getCommentByPost(postId: postId, pagination: query);
      final comments = response.data;

      if (comments == null) {
        return Left(
          ServerFailure(message: 'Failed to fetch comments: no data returned'),
        );
      }

      return Right(comments.map(CommentMapper.fromModel).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getReplies({
    required String commentId,
    required PaginationParams? query,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final BaseResponse<List<CommentModel>> response = await remote.getReplies(
        commentId: commentId,
        pagination: query,
      );
      final comments = response.data;

      if (comments == null) {
        return Left(
          ServerFailure(message: 'Failed to fetch comments: no data returned'),
        );
      }

      return Right(comments.map(CommentMapper.fromModel).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}
