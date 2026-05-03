import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:social_app/core/theme/app_size.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/presentations/conversation/widgets/chat_time_divider.dart';
import 'package:social_app/presentations/conversation/widgets/message_bubble_widget.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.messages,
    required this.currentUserId,
    required this.scrollController,
  });

  final List<MessageEntity> messages;
  final String? currentUserId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.messageCircle,
              size: 48,
              color: theme.colorScheme.outline.withAlpha(100),
            ),
            const SizedBox(height: AppSize.sm),
            Text(
              'No messages yet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppSize.xs),
            Text(
              'Say hello! 👋',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(top: AppSize.sm, bottom: AppSize.sm + 56),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMine = message.senderId == currentUserId;
        final currentMessageTime = message.createdAt.toDate();

        bool showTimeDivider = false;
        if (index == messages.length - 1) {
          showTimeDivider = true;
        } else {
          final olderMessageTime = messages[index + 1].createdAt.toDate();
          final gap = currentMessageTime.difference(olderMessageTime);
          if (gap.inMinutes > 20) showTimeDivider = true;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showTimeDivider) ChatTimeDivider(date: currentMessageTime),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSize.xs),
              child: MessageBubbleWidget(
                message: message,
                isMine: isMine,
                showAvatar: !isMine,
              ),
            ),
          ],
        );
      },
    );
  }
}
