import 'package:equatable/equatable.dart';
import 'package:social_app/features/post/domain/entities/post_entity.dart';

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
