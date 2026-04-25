import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:social_app/core/theme/app_size.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.hasText,
    required this.onSend,
    this.onAttach,
    this.onEmoji,
  });

  final TextEditingController controller;
  final bool hasText;
  final VoidCallback onSend;
  final VoidCallback? onAttach;
  final VoidCallback? onEmoji;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.sm,
          vertical: AppSize.sm,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.colorScheme.outline.withAlpha(30)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(LucideIcons.paperclip, color: theme.colorScheme.outline),
              onPressed: onAttach,
              tooltip: 'Attach file',
            ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppSize.borderRadiusXLarge),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Message…',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSize.md,
                      vertical: AppSize.sm + 2,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSize.xs),
            SizedBox(
              width: 42,
              height: 42,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: hasText
                    ? ChatSendButton(key: const ValueKey('send'), onTap: onSend)
                    : ChatEmojiButton(
                        key: const ValueKey('emoji'),
                        onTap: onEmoji ?? () {},
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatSendButton extends StatelessWidget {
  const ChatSendButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          LucideIcons.sendHorizontal,
          size: AppSize.iconSmall + 2,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class ChatEmojiButton extends StatelessWidget {
  const ChatEmojiButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: onTap,
      icon: Icon(LucideIcons.smile, color: theme.colorScheme.outline),
      tooltip: 'Emoji',
    );
  }
}
