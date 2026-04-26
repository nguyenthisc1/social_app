import 'package:social_app/core/core.dart';
import 'package:social_app/core/network/base_response.dart';
import 'package:social_app/features/post/data/datasources/post_local_data_source.dart';
import 'package:social_app/features/post/data/datasources/post_remote_data_source.dart';
import 'package:social_app/features/post/data/models/post_model.dart';
import 'package:social_app/features/post/domain/entities/post_entity.dart';
import 'package:social_app/features/post/domain/entities/post_enum.dart';
import 'package:social_app/features/post/domain/mappers/post_mapper.dart';
import 'package:social_app/features/post/domain/post_exceptions.dart';
import 'package:social_app/features/post/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;
  final PostLocalDataSource local;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  @override
  Future<PostEntity> createPost({
    required String content,
    required PostVisibility visibility,
    required PostType type,
  }) async {
    if (!await networkInfo.isConnected) {
      throw PostCreateException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at createPost.',
      );
    }
    try {
      final BaseResponse<PostModel> response = await remote.createPost(
        content: content,
        visibility: visibility.name,
        type: type.name,
      );
      final postModel = response.data;
      if (postModel == null) {
        throw PostCreateException(
          debugMessage: 'Post creation failed: no data returned.',
        );
      }
      return PostMapper.fromModel(postModel);
    } catch (e) {
      if (e is PostException) rethrow;
      throw PostCreateException(
        debugMessage: 'Failed to create post: $e',
        cause: e,
      );
    }
  }

  @override
  Future<PostEntity> updatePost({
    required String postId,
    required String content,
    required PostVisibility visibility,
    required PostType type,
  }) async {
    if (!await networkInfo.isConnected) {
      throw PostUpdateException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at updatePost.',
      );
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
        throw PostUpdateException(
          debugMessage: 'Post update failed: no data returned.',
        );
      }
      return PostMapper.fromModel(postModel);
    } catch (e) {
      if (e is PostException) rethrow;
      throw PostUpdateException(
        debugMessage: 'Failed to update post $postId: $e',
        cause: e,
      );
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    if (!await networkInfo.isConnected) {
      throw PostDeleteException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at deletePost.',
      );
    }
    try {
      await remote.deletePost(postId);
    } catch (e) {
      if (e is PostException) rethrow;
      throw PostDeleteException(
        debugMessage: 'Failed to delete post $postId: $e',
        cause: e,
      );
    }
  }

  @override
  Future<List<PostEntity>> getHomePost() async {
    if (!await networkInfo.isConnected) {
      throw PostLoadException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at getHomePost.',
      );
    }
    try {
      final BaseResponse<List<PostModel>> response = await remote.getHomePost();
      final postModels = response.data;
      if (postModels == null) {
        throw PostLoadException(
          debugMessage: 'Failed to load posts: no data returned.',
        );
      }
      await local.cachePosts(postModels);
      return PostMapper.fromModelList(postModels);
    } catch (e) {
      if (e is PostException) rethrow;
      throw PostLoadException(
        debugMessage: 'Failed to load home posts: $e',
        cause: e,
      );
    }
  }

  @override
  Future<PostEntity> getPost(String postId) async {
    if (!await networkInfo.isConnected) {
      throw PostLoadException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at getPost.',
      );
    }
    try {
      final BaseResponse<PostModel> response = await remote.getPost(postId);
      final postModel = response.data;
      if (postModel == null) {
        throw PostLoadException(
          userMessage: 'Post not found.',
          debugMessage: 'Failed to load post $postId: no data returned.',
        );
      }
      return PostMapper.fromModel(postModel);
    } catch (e) {
      if (e is PostException) rethrow;
      throw PostLoadException(
        userMessage: 'Unable to load post.',
        debugMessage: 'Failed to get post $postId: $e',
        cause: e,
      );
    }
  }

  @override
  Future<List<PostEntity>> getPostsByUser(String viewerId) async {
    if (!await networkInfo.isConnected) {
      throw PostLoadException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at getPostsByUser.',
      );
    }
    try {
      final BaseResponse<List<PostModel>> response = await remote
          .getPostsByUser(viewerId);
      final postModels = response.data;
      if (postModels == null) {
        throw PostLoadException(
          debugMessage: 'Failed to load user posts: no data returned.',
        );
      }
      return PostMapper.fromModelList(postModels);
    } catch (e) {
      if (e is PostException) rethrow;
      throw PostLoadException(
        userMessage: 'Unable to load posts.',
        debugMessage: 'Failed to get posts for user $viewerId: $e',
        cause: e,
      );
    }
  }
}
