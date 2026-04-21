import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/presentation/post/bloc/create_post_story_bloc.dart';
import 'package:social_app/presentation/post/widgets/create_post/create_post_news_widget.dart';
import 'package:social_app/presentation/post/widgets/create_post/create_post_story_widget.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({super.key});

  @override
  _CreatePostWidgetState createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final int _initialIndex = 1;
  late final PageController _pageController;
  final ScrollController _navController = ScrollController();
  late int _currentIndex;
  late final StoryBloc _storyBloc;

  final List<String> _tabs = ['News', 'Story', 'Footage', 'Live'];

  @override
  void initState() {
    super.initState();
    _currentIndex = _initialIndex;
    _pageController = PageController(initialPage: _initialIndex);
    _storyBloc = StoryBloc();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _centerTab(index);
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  void _centerTab(int index) {
    const tabWidth = 80.0;

    final screenWidth = MediaQuery.of(context).size.width;

    final offset = (index * tabWidth) - (screenWidth / 2) + (tabWidth / 2);

    _navController.animateTo(
      offset.clamp(
        _navController.position.minScrollExtent,
        _navController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    bool isStory = _currentIndex == 1;

    return BlocProvider(
      create: (_) => _storyBloc,
      child: Stack(
        children: [
          // Fullscreen PageView (disable user scroll)
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _centerTab(index);
              },
              children: [const CreatePostNewsWidget(), CreatePostStoryWidget()],
            ),
          ),

          // Bottom positioned tab-bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SingleChildScrollView(
                    controller: _navController,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.20,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppSize.borderRadiusFull,
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.sm,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSize.borderRadiusFull,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_tabs.length, (index) {
                              final isSelected = _currentIndex == index;
                              return GestureDetector(
                                onTap: () => _onTabTapped(index),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSize.md,
                                    horizontal: AppSize.sm,
                                  ),
                                  child: Text(
                                    _tabs[index].toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white30,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // local photos
                  Positioned(
                    left: AppSize.xl,
                    top: 0,
                    bottom: 0,
                    child: isStory
                        ? Icon(LucideIcons.image, color: Colors.white)
                        : const SizedBox(width: 24),
                  ),

                  // Change camera lens
                  BlocSelector<StoryBloc, StoryState, StoryCameraDirection>(
                    selector: (state) => state.cameraDirection,
                    builder: (context, cameraDirection) => Positioned(
                      right: AppSize.xl,
                      top: 0,
                      bottom: 0,
                      child: isStory
                          ? IconButton(
                              onPressed: () {
                                context.read<StoryBloc>().add(
                                  SwitchCameraDirectionEvent(),
                                );
                              },
                              icon: Icon(
                                LucideIcons.switchCamera,
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox(width: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
