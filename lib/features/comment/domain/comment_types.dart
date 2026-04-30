import 'package:equatable/equatable.dart';
import 'package:social_app/features/comment/domain/value_objects/pagination_params.dart';

class CreateCommentCommand extends Equatable {
  final String postId;
  final String content;
  final String? parentCommentId;

  const CreateCommentCommand({
    required this.postId,
    required this.content,
    this.parentCommentId,
  });

  @override
  List<Object?> get props => [postId, content, parentCommentId];
}

class UpdateCommentCommand extends Equatable {
  final String commentId;
  final String content;

  const UpdateCommentCommand({
    required this.commentId,
    required this.content,
  });

  @override
  List<Object?> get props => [commentId, content];
}

class DeleteCommentCommand extends Equatable {
  final String commentId;

  const DeleteCommentCommand({required this.commentId});

  @override
  List<Object?> get props => [commentId];
}

class GetCommentsByPostQuery extends Equatable {
  final String postId;
  final PaginationParams? query;

  const GetCommentsByPostQuery({
    required this.postId,
    this.query,
  });

  @override
  List<Object?> get props => [postId, query];
}

class GetRepliesQuery extends Equatable {
  final String commentId;
  final PaginationParams? query;

  const GetRepliesQuery({
    required this.commentId,
    this.query,
  });

  @override
  List<Object?> get props => [commentId, query];
}
