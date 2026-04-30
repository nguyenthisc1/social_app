import 'package:social_app/core/data/http/http_response.dart';
import 'package:social_app/features/comment/data/models/comment_model.dart';
import 'package:social_app/features/comment/domain/value_objects/pagination_params.dart';

abstract class CommentRemoteDataSource {
  Future<HttpResponse<CommentModel>> createComment({
    required String postId,
    required String content,
    String? parentCommentId,
  });

  Future<HttpResponse<CommentModel>> updateComment({
    required String commentId,
    required String content,
  });

  Future<HttpResponse<void>> deleteComment(String commentId);

  Future<HttpResponse<List<CommentModel>>> getCommentByPost({
    required String postId,
    PaginationParams? pagination,
  });

  Future<HttpResponse<List<CommentModel>>> getReplies({
    required String commentId,
    PaginationParams? pagination,
  });
}
