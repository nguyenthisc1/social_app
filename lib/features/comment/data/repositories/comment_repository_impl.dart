import 'package:social_app/core/core.dart';
import 'package:social_app/core/network/base_response.dart';
import 'package:social_app/features/comment/data/datasources/comment_remote_data_source.dart';
import 'package:social_app/features/comment/data/models/comment_model.dart';
import 'package:social_app/features/comment/domain/comment_exceptions.dart';
import 'package:social_app/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app/features/comment/domain/mappers/comment_mapper.dart';
import 'package:social_app/features/comment/domain/repositories/comment_repository.dart';
import 'package:social_app/features/comment/domain/value_objects/pagination_params.dart';

class CommentRepositoryImpl extends CommentRepository {
  final CommentRemoteDataSource remote;
  final NetworkInfo networkInfo;

  CommentRepositoryImpl({required this.remote, required this.networkInfo});

  @override
  Future<CommentEntity> createComment({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    if (!await networkInfo.isConnected) {
      throw CommentCreateException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network is offline at comment creation.',
      );
    }
    try {
      final BaseResponse<CommentModel> response = await remote.createComment(
        postId: postId,
        content: content,
        parentCommentId: parentCommentId,
      );
      final commentModel = response.data;

      if (commentModel == null) {
        throw CommentCreateException(
          userMessage: 'Unable to post comment.',
          debugMessage: 'Failed to create comment: No data returned.',
        );
      }

      return CommentMapper.fromModel(commentModel);
    } catch (e) {
      throw CommentCreateException(
        userMessage: 'Unable to post comment.',
        debugMessage: 'Failed to create comment: $e',
        cause: e,
      );
    }
  }

  @override
  Future<CommentEntity> updateComment({
    required String commentId,
    required String content,
  }) async {
    if (!await networkInfo.isConnected) {
      throw CommentUpdateException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network is offline at comment update.',
      );
    }
    try {
      final BaseResponse<CommentModel> response = await remote.updateComment(
        commentId: commentId,
        content: content,
      );
      final commentModel = response.data;

      if (commentModel == null) {
        throw CommentUpdateException(
          userMessage: 'Unable to update comment.',
          debugMessage: 'Failed to update comment: No data returned.',
        );
      }

      return CommentMapper.fromModel(commentModel);
    } catch (e) {
      throw CommentUpdateException(
        userMessage: 'Unable to update comment.',
        debugMessage: 'Failed to update comment: $e',
        cause: e,
      );
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    if (!await networkInfo.isConnected) {
      throw CommentDeleteException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network is offline at comment delete.',
      );
    }
    try {
      await remote.deleteComment(commentId);
      return;
    } catch (e) {
      throw CommentDeleteException(
        userMessage: 'Unable to delete comment.',
        debugMessage: 'Failed to delete comment: $e',
        cause: e,
      );
    }
  }

  @override
  Future<List<CommentEntity>> getCommentsByPost({
    required String postId,
    required PaginationParams? query,
  }) async {
    if (!await networkInfo.isConnected) {
      throw CommentLoadException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network is offline at comments fetch (by post).',
      );
    }
    try {
      final BaseResponse<List<CommentModel>> response = await remote
          .getCommentByPost(postId: postId, pagination: query);
      final comments = response.data;

      if (comments == null) {
        throw CommentLoadException(
          userMessage: 'Unable to load comments.',
          debugMessage: 'Failed to load comments: No data returned.',
        );
      }
      return comments.map(CommentMapper.fromModel).toList();
    } catch (e) {
      throw CommentLoadException(
        userMessage: 'Unable to load comments.',
        debugMessage: 'Failed to load comment data: $e',
        cause: e,
      );
    }
  }

  @override
  Future<List<CommentEntity>> getReplies({
    required String commentId,
    required PaginationParams? query,
  }) async {
    if (!await networkInfo.isConnected) {
      throw CommentLoadException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network is offline at replies fetch.',
      );
    }
    try {
      final BaseResponse<List<CommentModel>> response = await remote.getReplies(
        commentId: commentId,
        pagination: query,
      );
      final comments = response.data;

      if (comments == null) {
        throw CommentLoadException(
          userMessage: 'Unable to load comments.',
          debugMessage: 'Failed to load replies: No data returned.',
        );
      }
      return comments.map(CommentMapper.fromModel).toList();
    } catch (e) {
      throw CommentLoadException(
        userMessage: 'Unable to load comments.',
        debugMessage: 'Failed to load comment replies: $e',
        cause: e,
      );
    }
  }
}
