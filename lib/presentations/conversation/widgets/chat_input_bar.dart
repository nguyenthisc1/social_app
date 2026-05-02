import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app/core/theme/app_size.dart';
import 'package:social_app/core/widgets/expanded_modal_bottom_sheet.dart';
import 'package:social_app/core/widgets/gallery_grid_select.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.hasText,
    required this.onSend,
    this.onAttach,
    this.onEmoji,
    required this.images,
  });

  final TextEditingController controller;
  final bool hasText;
  final VoidCallback onSend;
  final VoidCallback? onAttach;
  final VoidCallback? onEmoji;
  final List<AssetEntity> images;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void openGalleryModalBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        // useSafeArea: true,
        // showDragHandle: true,
        builder: (context) => ExpandedModalBottomSheet(
          child: GalleryGridSelect(images: images)
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSize.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.sm,
          vertical: AppSize.xs,
        ),
        constraints: BoxConstraints(maxHeight: 120),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppSize.borderRadiusXLarge),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: hasText
                  ? IconInputButton(
                      key: const ValueKey('search'),
                      onPressed: onSend,
                      icon: LucideIcons.search,
                      colorIcon: theme.colorScheme.primary,
                      color: Colors.white,
                      tooltip: 'search',
                    )
                  : IconInputButton(
                      key: const ValueKey('camera'),
                      onPressed: () {},
                      icon: Icons.camera_alt,
                      color: theme.colorScheme.primary,
                      tooltip: 'Camera',
                    ),
            ),
            const SizedBox(width: AppSize.xs),
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: 1,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: theme.textTheme.bodyMedium,
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
                  child: !hasText
                      ? Row(
                          key: const ValueKey('actions'),
                          children: [
                            IconInputButton(
                              onPressed: () {},
                              icon: LucideIcons.mic,
                              tooltip: 'Emoji',
                            ),
                            IconInputButton(
                              onPressed: () {
                                onAttach;
                                openGalleryModalBottomSheet();
                              },
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
                  child: hasText
                      ? IconInputButton(
                          key: const ValueKey('send'),
                          onPressed: onSend,
                          icon: LucideIcons.send,
                          colorIcon: theme.colorScheme.primary,
                          tooltip: 'Send',
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ],
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
