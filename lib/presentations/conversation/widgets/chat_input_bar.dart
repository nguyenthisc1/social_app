import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:social_app/core/theme/app_size.dart';
import 'package:social_app/core/utils/utils.dart';

class ChatInputBar extends StatefulWidget {
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
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: AppSize.sm,
        left: AppSize.sm,
        bottom: AppSize.xs,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.borderRadiusXLarge),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.xs,
              vertical: AppSize.xs,
            ),
            constraints: BoxConstraints(maxHeight: 120),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(AppSize.borderRadiusXLarge),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: widget.hasText
                      ? IconInputButton(
                          key: const ValueKey('search'),
                          onPressed: widget.onSend,
                          icon: LucideIcons.search,
                          colorIcon: context.theme.colorScheme.primary,
                          color: Colors.white,
                          tooltip: 'search',
                        )
                      : IconInputButton(
                          key: const ValueKey('camera'),
                          onPressed: () {},
                          icon: Icons.camera_alt,
                          color: context.theme.colorScheme.primary,
                          tooltip: 'Camera',
                        ),
                ),
                const SizedBox(width: AppSize.xs),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    style: context.theme.textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      hintText: 'Message…',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: AppSize.sm,
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.xs),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: !widget.hasText
                          ? Row(
                              key: const ValueKey('actions'),
                              children: [
                                IconInputButton(
                                  onPressed: () {},
                                  icon: LucideIcons.mic,
                                  tooltip: 'Emoji',
                                ),
                                IconInputButton(
                                  onPressed: () => widget.onAttach?.call(),
                                  icon: LucideIcons.image,
                                  tooltip: 'Gallery',
                                ),
                                IconInputButton(
                                  onPressed: () {},
                                  icon: LucideIcons.sticker,
                                  tooltip: 'Emoji',
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: widget.hasText
                          ? IconInputButton(
                              key: const ValueKey('send'),
                              onPressed: widget.onSend,
                              icon: LucideIcons.send,
                              colorIcon: context.theme.colorScheme.primary,
                              tooltip: 'Send',
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconInputButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? size;
  final IconData icon;
  final Color? color;
  final Color? colorIcon;
  final String tooltip;

  const IconInputButton({
    super.key,
    required this.onPressed,
    this.size = 36,
    required this.icon,
    required this.tooltip,
    this.color,
    this.colorIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(AppSize.borderRadiusFull),
      ),
      child: IconButton(
        padding: const EdgeInsets.all(0),
        iconSize: size! / 1.5,
        icon: Icon(
          icon,
          color:
              colorIcon ??
              (color != null ? Colors.white : theme.colorScheme.onSurface),
        ),

        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}
