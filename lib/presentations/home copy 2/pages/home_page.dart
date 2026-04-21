import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:social_app/core/di/service_locator.dart';
import 'package:social_app/core/theme/app_size.dart';
import 'package:social_app/presentations/post/bloc/post_bloc.dart';
import 'package:social_app/presentations/post/widgets/post_list_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => sl<PostBloc>(),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSize.md),
        children: [
          // Stories row placeholder
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 8,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final isYourStory = index == 0;
                return Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isYourStory
                            ? null
                            : const LinearGradient(
                                colors: [Color(0xFFDE0046), Color(0xFFF7A34B)],
                              ),
                        border: isYourStory
                            ? Border.all(
                                color: theme.colorScheme.outline.withAlpha(60),
                              )
                            : null,
                      ),
                      padding: const EdgeInsets.all(2.5),
                      child: CircleAvatar(
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        child: isYourStory
                            ? Icon(
                                LucideIcons.plus,
                                size: 20,
                                color: theme.colorScheme.primary,
                              )
                            : Text('$index', style: theme.textTheme.titleSmall),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isYourStory ? 'Your story' : 'user_$index',
                      style: theme.textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1),

          PostList(),
        ],
      ),
    );
  }
}
