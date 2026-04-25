import 'package:flutter/material.dart';
import 'package:social_app/core/utils/date_formatter.dart';
import 'package:social_app/core/utils/extensions.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_type.dart';
import 'package:social_app/features/message/domain/entites/message_type.dart';
import 'package:social_app/features/user/domain/entites/user_entity.dart';

class ConversationListItem extends StatelessWidget {
  const ConversationListItem({
    super.key,
    required this.conversation,
    required this.currentUserId,
    this.otherUser,
    required this.onTap,
  });

  final ConversationEntity conversation;
  final String? currentUserId;
  final UserEntity? otherUser;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isGroup = conversation.type == ConversationType.group;
    final title = isGroup
        ? (conversation.name.trim().isEmpty ? 'Unnamed group' : conversation.name)
        : (otherUser?.username ?? 'Unknown user');
    final avatarLabel = title.characters.first.toUpperCase();
    final avatarUrl = isGroup ? conversation.avatarUrl : otherUser?.avatarUrl;
    final unreadCount = conversation.unreadCountMap[currentUserId]?.count ?? 0;
    final isUnread = unreadCount > 0;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: context.colorScheme.surfaceContainerHighest,
        backgroundImage: avatarUrl?.isNotEmpty == true ? NetworkImage(avatarUrl!) : null,
        child: avatarUrl?.isNotEmpty == true
            ? null
            : Text(avatarLabel, style: context.textTheme.titleMedium),
      ),
      title: Text(
        title,
        style: context.textTheme.titleSmall?.copyWith(
          fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _buildSubtitle(unreadCount),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(
          color: isUnread ? context.colorScheme.onSurface : context.colorScheme.outline,
          fontWeight: isUnread ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
      onTap: onTap,
      trailing: ConversationItemTrailing(
        lastMessageTime: conversation.lastMessage?.createdAt.toDate(),
        isUnread: isUnread,
      ),
    );
  }

  String _buildSubtitle(int unreadCount) {
    if (unreadCount > 1) return '$unreadCount new messages';
    if (conversation.lastMessage?.type == MessageType.text) {
      return conversation.lastMessage?.text ?? '';
    }
    if (conversation.lastMessage?.type == MessageType.image) return 'Sent an image';
    return '';
  }
}

class ConversationItemTrailing extends StatelessWidget {
  const ConversationItemTrailing({
    super.key,
    required this.lastMessageTime,
    required this.isUnread,
  });

  final DateTime? lastMessageTime;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          lastMessageTime == null
              ? ''
              : DateFormatter.formatMessageTime(lastMessageTime!),
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        if (isUnread) ...[
          const SizedBox(height: 4),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }
}
