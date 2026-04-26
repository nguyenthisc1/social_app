import 'package:social_app/core/core.dart';
import 'package:social_app/core/data/http/http_response.dart';
import 'package:social_app/core/utils/app_constants.dart';
import 'package:social_app/features/post/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<HttpResponse<PostModel>> createPost({
    required String content,
    required String visibility,
    required String type,
  });

  Future<HttpResponse<PostModel>> updatePost({
    required String postId,
    required String content,
    required String visibility,
    required String type,
  });

  Future<HttpResponse<void>> deletePost(String postId);

  Future<HttpResponse<PostModel>> getPost(String postId);

  Future<HttpResponse<List<PostModel>>> getHomePost();

  Future<HttpResponse<List<PostModel>>> getPostsByUser(String viewerId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiClient apiClient;

  PostRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<HttpResponse<List<PostModel>>> getHomePost() async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: ApiEndpoints.feedHome,
    );

    return HttpResponse.fromJson(
      response,
      (data) => (data as List<dynamic>)
          .map((item) => PostModel.fromJson(item))
          .toList(),
    );
  }

  @override
  Future<HttpResponse<PostModel>> getPost(String postId) async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: '${ApiEndpoints.getPost}/$postId',
    );

    return HttpResponse.fromJson(
      response,
      (data) => PostModel.fromJson(data['post']),
    );
  }

  @override
  Future<HttpResponse<PostModel>> createPost({
    required String content,
    required String visibility,
    required String type,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: ApiEndpoints.createPost,
      body: {'content': content, 'visibility': visibility, 'type': type},
    );

    return HttpResponse.fromJson(
      response,
      (data) => PostModel.fromJson(data['post']),
    );
  }

  @override
  Future<HttpResponse<PostModel>> updatePost({
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

    return HttpResponse.fromJson(
      response,
      (data) => PostModel.fromJson(data['post']),
    );
  }

  @override
  Future<HttpResponse<bool>> deletePost(String postId) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: '${ApiEndpoints.softdeletePost}/$postId',
    );

    return HttpResponse.fromJson(response, (data) => data['success'] == true);
  }

  @override
  Future<HttpResponse<List<PostModel>>> getPostsByUser(String viewerId) async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: '${ApiEndpoints.postsByUser}/$viewerId',
    );

    return HttpResponse.fromJson(
      response,
      (data) => (data['posts'] as List<dynamic>)
          .map((item) => PostModel.fromJson(item))
          .toList(),
    );
  }
}
