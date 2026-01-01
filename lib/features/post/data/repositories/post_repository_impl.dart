import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/core/network/base_response.dart';
import 'package:social_app/features/post/data/datasources/post_local_data_source.dart';
import 'package:social_app/features/post/data/datasources/post_remote_data_source.dart';
import 'package:social_app/features/post/data/models/post_model.dart';
import 'package:social_app/features/post/domain/entites/post_entity.dart';
import 'package:social_app/features/post/domain/entites/post_enum.dart';
import 'package:social_app/features/post/domain/mappers/post_mapper.dart';
import 'package:social_app/features/post/domain/repositories/post_repository.dart';

class PostRepositoryImpl extends PostRepository {
  final PostRemoteDataSource remote;
  final PostLocalDataSource local;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PostEntity>> createPost({
    required String content,
    required PostVisibility visibility,
    required PostType type,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final BaseResponse<PostModel> response = await remote.createPost(
        content: content,
        visibility: visibility.name,
        type: type.name,
      );

      final postModel = response.data;

      if (postModel == null) {
        return Left(
          ServerFailure(message: 'Post creation failed: no data returned'),
        );
      }

      return Right(PostMapper.fromModel(postModel));
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
  Future<Either<Failure, PostEntity>> updatePost({
    required String postId,
    required String content,
    required PostVisibility visibility,
    required PostType type,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final BaseResponse<PostModel> response = await remote.updatePost(
        postId: postId,
        content: content,
        visibility: visibility.name,
        type: type.name,
      );

      final postModel = response.data;

      if (postModel == null) {
        return Left(
          ServerFailure(message: 'Post update failed: no data returned'),
        );
      }

      return Right(PostMapper.fromModel(postModel));
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
  Future<Either<Failure, bool>> deletePost(String postId) async {
    try {
      await remote.deletePost(postId);
      return const Right(true);
    } on Exception catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getHomePost() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final BaseResponse<List<PostModel>> response = await remote.getHomePost();

      final postModels = response.data;

      if (postModels == null) {
        return Left(
          ServerFailure(message: 'Failed to load posts: no data returned'),
        );
      }

      await local.cachePosts(postModels);

      return Right(PostMapper.fromModelList(postModels));
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
  Future<Either<Failure, PostEntity>> getPost(String postId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final BaseResponse<PostModel> response = await remote.getPost(postId);

      final postModel = response.data;

      if (postModel == null) {
        return Left(
          ServerFailure(message: 'Failed to load post: no data returned'),
        );
      }

      return Right(PostMapper.fromModel(postModel));
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
  Future<Either<Failure, List<PostEntity>>> getPostsByUser(
    String viewerId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final BaseResponse<List<PostModel>> response = await remote
          .getPostsByUser(viewerId);

      final postModels = response.data;

      if (postModels == null) {
        return Left(
          ServerFailure(message: 'Failed to load user posts: no data returned'),
        );
      }

      return Right(PostMapper.fromModelList(postModels));
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
