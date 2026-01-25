import 'package:social_app/core/entities/pagination_param.dart';
import 'package:social_app/core/network/base_response.dart';
import 'package:social_app/features/comment/data/models/comment_model.dart';

abstract class CommentRemoteDataSource {
  Future<BaseResponse<CommentModel>> createComment({
    required String postId,
    required String content,
    String? parentCommentId,
  });

  Future<BaseResponse<CommentModel>> updateComment({
    required String commentId,
    required String content,
  });

  Future<BaseResponse<void>> deleteComment(String commentId);

  Future<BaseResponse<List<CommentModel>>> getCommentByPost({
    required String postId,
    PaginationParams? pagination,
  });

  Future<BaseResponse<List<CommentModel>>> getReplies({
    required String commentId,
    PaginationParams? pagination,
  });
}
