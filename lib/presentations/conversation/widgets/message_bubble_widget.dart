import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app/core/theme/app_size.dart';
import 'package:social_app/core/widgets/loading_indicator.dart';
import 'package:social_app/features/message/domain/entites/message_delivery_status.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/entites/message_type.dart';

class MessageBubbleWidget extends StatefulWidget {
  const MessageBubbleWidget({
    super.key,
    required this.message,
    required this.isMine,
    required this.showAvatar,
  });

  final MessageEntity message;
  final bool isMine;
  final bool showAvatar;

  @override
  State<MessageBubbleWidget> createState() => _MessageBubbleWidgetState();
}

class _MessageBubbleWidgetState extends State<MessageBubbleWidget> {
  bool _showTime = false;

  String get _timeLabel =>
      DateFormat('HH:mm').format(widget.message.createdAt.toDate());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => setState(() => _showTime = !_showTime),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(
          left: widget.isMine ? 64 : AppSize.lg,
          right: widget.isMine ? AppSize.lg : 64,
          bottom: AppSize.xs,
        ),
        child: Row(
          mainAxisAlignment: widget.isMine
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!widget.isMine) ...[
              if (widget.showAvatar)
                CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  child: Text(
                    widget.message.senderId.isNotEmpty
                        ? widget.message.senderId[0].toUpperCase()
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
                crossAxisAlignment: widget.isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  _buildBubble(context, theme),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: _showTime
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              left: 4,
                              right: 4,
                            ),
                            child: Text(
                              _timeLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.outline,
                                fontSize: 10,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(BuildContext context, ThemeData theme) {
    final isImage = widget.message.type == MessageType.image;

    if (isImage && widget.message.mediaUrl != null) {
      return ClipRRect(
        borderRadius: _bubbleRadius(),
        child: Image.network(
          widget.message.mediaUrl!,
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
      mainAxisAlignment: widget.isMine
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.isMine &&
            widget.message.status == MessageDeliveryStatus.sending) ...[
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
              color: widget.isMine
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHigh,
              borderRadius: _bubbleRadius(),
            ),
            child: Text(
              widget.message.text ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: widget.isMine
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

    if (widget.isMine) {
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
