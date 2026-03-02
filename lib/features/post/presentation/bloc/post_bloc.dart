import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/post/domain/usecases/create_post_usecase.dart';
import 'package:social_app/features/post/domain/usecases/delete_post_usecase.dart';
import 'package:social_app/features/post/domain/usecases/get_home_post_usecase.dart';
import 'package:social_app/features/post/domain/usecases/get_post_usecase.dart';
import 'package:social_app/features/post/domain/usecases/get_posts_by_user_usecase.dart';
import 'package:social_app/features/post/domain/usecases/update_post_usecase.dart';
import 'package:social_app/features/post/presentation/bloc/post_event.dart';
import 'package:social_app/features/post/presentation/bloc/post_state.dart';

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
    print(result);

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
