import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/presentation/post/bloc/create_post_story_bloc.dart';
import 'package:social_app/presentation/post/widgets/create_post/create_post_widget.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoryBloc>(
      create: (_) => StoryBloc()..add(OpenCamera()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        extendBody: true,
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        body: CreatePostWidget(),
      ),
    );
  }
}
