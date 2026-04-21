import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/post/domain/entities/post_entity.dart';
import 'package:social_app/features/post/domain/entities/post_enum.dart';
import 'package:social_app/features/post/domain/usecases/create_post_usecase.dart';
import 'package:social_app/features/post/domain/usecases/delete_post_usecase.dart';
import 'package:social_app/features/post/domain/usecases/get_home_post_usecase.dart';
import 'package:social_app/features/post/domain/usecases/get_post_usecase.dart';
import 'package:social_app/features/post/domain/usecases/get_posts_by_user_usecase.dart';
import 'package:social_app/features/post/domain/usecases/update_post_usecase.dart';

/// Post Events & States in one file

// --------------- EVENTS -----------------
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

  @override
  List<Object?> get props => [content, visibility, type];
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
  List<Object?> get props => [postId, content, visibility, type];
}

// --------------- STATES -----------------
class PostState extends Equatable {
  final List<PostEntity> posts;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? error;

  const PostState({
    this.posts = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.error,
  });

  PostState copyWith({
    List<PostEntity>? posts,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? error,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    posts,
    isLoading,
    isRefreshing,
    isLoadingMore,
    hasReachedMax,
    error,
  ];
}

// -------------- BLOC --------------------
class PostBloc extends Bloc<PostEvent, PostState> {
  final CreatePostUsecase createPostUsecase;
  final GetHomePostUsecase getHomePostUsecase;
  final GetPostUsecase getPostUsecase;
  final GetPostsByUserUsecase getPostsByUserUsecase;
  final UpdatePostUsecase updatePostUsecase;
  final DeletePostUsecase deletePostUsecase;

  PostBloc({
    required this.createPostUsecase,
    required this.getHomePostUsecase,
    required this.getPostUsecase,
    required this.getPostsByUserUsecase,
    required this.updatePostUsecase,
    required this.deletePostUsecase,
  }) : super(const PostState()) {
    on<PostFetched>(_onPostFetched);
    on<PostCreated>(_onPostCreated);
    on<PostDeleted>(_onPostDeleted);
    on<PostUpdated>(_onPostUpdated);
  }

  Future<void> _onPostFetched(
    PostFetched event,
    Emitter<PostState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getHomePostUsecase();

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (posts) => emit(
        state.copyWith(
          isLoading: false,
          posts: posts,
          error: null,
          hasReachedMax: false,
        ),
      ),
    );
  }

  Future<void> _onPostCreated(
    PostCreated event,
    Emitter<PostState> emit,
  ) async {
    final result = await createPostUsecase(
      content: event.content,
      visibility: event.visibility,
      type: event.type,
    );

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (post) => emit(state.copyWith(posts: [post, ...state.posts])),
    );
  }

  Future<void> _onPostDeleted(
    PostDeleted event,
    Emitter<PostState> emit,
  ) async {
    final result = await deletePostUsecase(event.postId);

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) => emit(
        state.copyWith(
          posts: state.posts.where((post) => post.id != event.postId).toList(),
        ),
      ),
    );
  }

  Future<void> _onPostUpdated(
    PostUpdated event,
    Emitter<PostState> emit,
  ) async {
    final result = await updatePostUsecase(
      postId: event.postId,
      content: event.content,
      visibility: event.visibility,
      type: event.type,
    );

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (newPost) => emit(
        state.copyWith(
          posts: state.posts
              .map((post) => post.id == newPost.id ? newPost : post)
              .toList(),
        ),
      ),
    );
  }
}
