import 'package:flutter/material.dart';
import 'package:social_app/core/theme/app_size.dart';
import 'package:social_app/core/widgets/loading_indicator.dart';
import 'package:social_app/features/message/domain/entites/message_delivery_status.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/entites/message_type.dart';

class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget({
    super.key,
    required this.message,
    required this.isMine,
    required this.showAvatar,
    required this.timeLabel,
  });

  final MessageEntity message;
  final bool isMine;
  final bool showAvatar;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: isMine ? 64 : AppSize.lg,
        right: isMine ? AppSize.lg : 64,
        bottom: AppSize.xs,
      ),
      child: Row(
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            if (showAvatar)
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                child: Text(
                  message.senderId.isNotEmpty
                      ? message.senderId[0].toUpperCase()
                      : '?',
                  style: theme.textTheme.labelSmall,
                ),
              )
            else
              const SizedBox(width: 32),
            const SizedBox(width: AppSize.sm),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                _buildBubble(context, theme),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    timeLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(BuildContext context, ThemeData theme) {
    final isImage = message.type == MessageType.image;

    if (isImage && message.mediaUrl != null) {
      return ClipRRect(
        borderRadius: _bubbleRadius(),
        child: Image.network(
          message.mediaUrl!,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => Container(
            width: 200,
            height: 160,
            color: theme.colorScheme.surfaceContainerHighest,
            alignment: Alignment.center,
            child: Icon(
              Icons.broken_image_outlined,
              color: theme.colorScheme.outline,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: isMine
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isMine && message.status == MessageDeliveryStatus.sending) ...[
          LoadingIndicator(size: 10, strokeWidth: 1),
        ],
        const SizedBox(width: AppSize.md),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.md,
              vertical: AppSize.sm + 2,
            ),
            decoration: BoxDecoration(
              color: isMine
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHigh,
              borderRadius: _bubbleRadius(),
            ),
            child: Text(
              message.text ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isMine
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  BorderRadius _bubbleRadius() {
    const r = Radius.circular(AppSize.borderRadiusLarge);
    const rSmall = Radius.circular(4);

    if (isMine) {
      return const BorderRadius.only(
        topLeft: r,
        topRight: r,
        bottomLeft: r,
        bottomRight: rSmall,
      );
    }
    return const BorderRadius.only(
      topLeft: r,
      topRight: r,
      bottomLeft: rSmall,
      bottomRight: r,
    );
  }
}
