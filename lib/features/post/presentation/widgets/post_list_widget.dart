import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_app/features/post/presentation/bloc/post_state.dart';
import 'package:social_app/features/post/presentation/widgets/post_widget.dart';

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        final posts = state.posts;
        final isLoading = state.isLoading;
        final isLoadingMore = state.isLoadingMore;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
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
