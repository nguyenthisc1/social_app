import 'package:equatable/equatable.dart';
import 'package:social_app/features/post/domain/entities/post_enum.dart';

class CreatePostCommand extends Equatable {
  final String content;
  final PostVisibility visibility;
  final PostType type;

  const CreatePostCommand({
    required this.content,
    required this.visibility,
    required this.type,
  });

  @override
  List<Object?> get props => [content, visibility, type];
}

class UpdatePostCommand extends Equatable {
  final String postId;
  final String content;
  final PostVisibility visibility;
  final PostType type;

  const UpdatePostCommand({
    required this.postId,
    required this.content,
    required this.visibility,
    required this.type,
  });

  @override
  List<Object?> get props => [postId, content, visibility, type];
}

class GetPostQuery extends Equatable {
  final String postId;

  const GetPostQuery({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class DeletePostCommand extends Equatable {
  final String postId;

  const DeletePostCommand({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class GetPostsByUserQuery extends Equatable {
  final String viewerId;

  const GetPostsByUserQuery({required this.viewerId});

  @override
  List<Object?> get props => [viewerId];
}
