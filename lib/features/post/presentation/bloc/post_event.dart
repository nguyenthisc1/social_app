import 'package:equatable/equatable.dart';
import 'package:social_app/features/post/domain/entities/post_enum.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class PostFetched extends PostEvent {}

class PostRefreshed extends PostEvent {}

class PostLoadMore extends PostEvent {}

class PostCreated extends PostEvent {
  final String content;
  final PostVisibility visibility;
  final PostType type;
  const PostCreated({
    required this.content,
    this.visibility = PostVisibility.private,
    this.type = PostType.text,
  });
}

class PostLikeToggled extends PostEvent {
  final String postId;
  const PostLikeToggled(this.postId);

  @override
  List<Object?> get props => [postId];
}

class PostDeleted extends PostEvent {
  final String postId;
  const PostDeleted(this.postId);

  @override
  List<Object?> get props => [postId];
}

class PostUpdated extends PostEvent {
  final String postId;
  final String content;
  final PostVisibility visibility;
  final PostType type;

  const PostUpdated(
    this.postId, {
    required this.content,
    required this.visibility,
    required this.type,
  });

  @override
  List<Object?> get props => [postId];
}
