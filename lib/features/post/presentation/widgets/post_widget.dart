import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:social_app/core/theme/app_size.dart';
import 'package:social_app/core/utils/text_helpers.dart';
import 'package:social_app/features/post/domain/entities/post_entity.dart';

class PostWidget extends StatelessWidget {
  final PostEntity post;

  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authorName = post.author.username
        .toString(); // Replace with correct property if any.
    final authorInitials = TextHelpers.getInitials(authorName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSize.md,
      children: [
        // Post header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.md,
            vertical: AppSize.sm,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: AppSize.avatarSmall,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                child: Text(authorInitials, style: theme.textTheme.labelMedium),
              ),
              const SizedBox(width: AppSize.md),
              Expanded(
                child: Text(
                  authorName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(LucideIcons.ellipsis, size: 20),
            ],
          ),
        ),

        // Post image
        if (post.images != null && post.images!.isNotEmpty)
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Image.network(
                post.images!.first,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    LucideIcons.image,
                    size: AppSize.iconXLarge,
                    color: theme.colorScheme.outline,
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          )
        else
          // Fallback placeholder if no images
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  LucideIcons.image,
                  size: AppSize.iconXLarge,
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ),

        // Post actions
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.md,
            vertical: AppSize.sm,
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.heart, size: AppSize.xl),
              const SizedBox(width: AppSize.md),
              const Icon(LucideIcons.messageCircle, size: AppSize.xl),
              const SizedBox(width: AppSize.md),
              const Icon(LucideIcons.send, size: AppSize.xl),
              const Spacer(),
              const Icon(LucideIcons.bookmark, size: AppSize.xl),
            ],
          ),
        ),


        // Likes & caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${TextHelpers.formatCount(post.likeCount)} likes',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSize.md),
              if (post.content != null && post.content!.isNotEmpty)
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: '$authorName ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: post.content),
                    ],
                  ),
                ),
              const SizedBox(height: AppSize.xs),
              Text(
                // Use TextHelpers.timeAgo for displaying "Just now" or relative time
                TextHelpers.timeAgo(post.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.md),
      ],
    );
  }
}
