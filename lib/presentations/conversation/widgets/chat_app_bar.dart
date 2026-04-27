import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:social_app/core/theme/app_size.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    super.key,
    required this.username,
    this.avatarUrl,
    this.onVoiceCall,
    this.onVideoCall,
  });

  final String username;
  final String? avatarUrl;
  final VoidCallback? onVoiceCall;
  final VoidCallback? onVideoCall;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowLeft),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primaryContainer,
            backgroundImage: avatarUrl?.isNotEmpty == true
                ? NetworkImage(avatarUrl!)
                : null,
            child: avatarUrl?.isNotEmpty == true
                ? null
                : Text(
                    username.isNotEmpty ? username[0].toUpperCase() : '?',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
          ),
          const SizedBox(width: AppSize.sm),
          Expanded(
            child: Text(
              username,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.phone),
          onPressed: onVoiceCall,
          tooltip: 'Voice call',
        ),
        IconButton(
          icon: const Icon(LucideIcons.video),
          onPressed: onVideoCall,
          tooltip: 'Video call',
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
