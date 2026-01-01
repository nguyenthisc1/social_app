import 'package:social_app/core/core.dart';
import 'package:social_app/core/network/base_response.dart';
import 'package:social_app/features/post/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<BaseResponse<PostModel>> createPost({
    required String content,
    required String visibility,
    required String type,
  });

  Future<BaseResponse<PostModel>> updatePost({
    required String postId,
    required String content,
    required String visibility,
    required String type,
  });

  Future<BaseResponse<void>> deletePost(String postId);

  Future<BaseResponse<PostModel>> getPost(String postId);

  Future<BaseResponse<List<PostModel>>> getHomePost();

  Future<BaseResponse<List<PostModel>>> getPostsByUser(String viewerId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiClient apiClient;

  PostRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<BaseResponse<List<PostModel>>> getHomePost() async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: ApiEndpoints.feedHome,
    );

    return BaseResponse.fromJson(
      response,
      (data) => (data['posts'] as List<dynamic>)
          .map((item) => PostModel.fromJson(item))
          .toList(),
    );
  }

  @override
  Future<BaseResponse<PostModel>> getPost(String postId) async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: '${ApiEndpoints.getPost}/$postId',
    );

    return BaseResponse.fromJson(
      response,
      (data) => PostModel.fromJson(data['post']),
    );
  }

  @override
  Future<BaseResponse<PostModel>> createPost({
    required String content,
    required String visibility,
    required String type,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: ApiEndpoints.createPost,
      body: {'content': content, 'visibility': visibility, 'type': type},
    );

    return BaseResponse.fromJson(
      response,
      (data) => PostModel.fromJson(data['post']),
    );
  }

  @override
  Future<BaseResponse<PostModel>> updatePost({
    required String postId,
    required String content,
    required String visibility,
    required String type,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: '${ApiEndpoints.updatePost}/$postId',
      body: {'content': content, 'visibility': visibility, 'type': type},
    );

    return BaseResponse.fromJson(
      response,
      (data) => PostModel.fromJson(data['post']),
    );
  }

  @override
  Future<BaseResponse<bool>> deletePost(String postId) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: '${ApiEndpoints.softdeletePost}/$postId',
    );

    return BaseResponse.fromJson(response, (data) => data['success'] == true);
  }

  @override
  Future<BaseResponse<List<PostModel>>> getPostsByUser(String viewerId) async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: '${ApiEndpoints.postsByUser}/$viewerId',
    );

    return BaseResponse.fromJson(
      response,
      (data) => (data['posts'] as List<dynamic>)
          .map((item) => PostModel.fromJson(item))
          .toList(),
    );
  }
}
