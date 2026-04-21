import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/presentations/post/bloc/post_bloc.dart';
import 'package:social_app/presentations/post/widgets/post_widget.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(PostFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PostBloc, PostState, PostState>(
      selector: (state) => state,
      builder: (context, state) {
        final posts = state.posts;
        final isLoading = state.isLoading;
        final isLoadingMore = state.isLoadingMore;

        if (isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.xl),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Column(
          children: [
            ...posts.map((post) => PostWidget(post: post)),
            if (isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.md),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
