import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      child: isYourStory
                          ? Icon(LucideIcons.plus,
                              size: 20, color: theme.colorScheme.primary)
                          : Text(
                              '$index',
                              style: theme.textTheme.titleSmall,
                            ),
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

        // Feed posts placeholder
        ...List.generate(3, (index) => _FeedPostPlaceholder(index: index)),
      ],
    );
  }
}

class _FeedPostPlaceholder extends StatelessWidget {
  final int index;
  const _FeedPostPlaceholder({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                child: Text('U', style: theme.textTheme.labelMedium),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'user_$index',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(LucideIcons.ellipsis, size: 20),
            ],
          ),
        ),

        // Post image placeholder
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Center(
              child: Icon(
                LucideIcons.image,
                size: 48,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ),

        // Post actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              const Icon(LucideIcons.heart, size: 24),
              const SizedBox(width: 14),
              const Icon(LucideIcons.messageCircle, size: 22),
              const SizedBox(width: 14),
              const Icon(LucideIcons.send, size: 22),
              const Spacer(),
              const Icon(LucideIcons.bookmark, size: 24),
            ],
          ),
        ),

        // Likes & caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${(index + 1) * 42} likes',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'user_$index ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(
                      text: 'This is a placeholder caption for the post.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '2 hours ago',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
