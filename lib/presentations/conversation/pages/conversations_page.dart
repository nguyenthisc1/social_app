import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/core/routes/app_routes.dart';
import 'package:social_app/core/utils/date_formatter.dart';
import 'package:social_app/core/utils/extensions.dart';
import 'package:social_app/core/widgets/in_app_status_wrapper.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_state.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_type.dart';
import 'package:social_app/features/message/domain/entites/message_type.dart';
import 'package:social_app/features/user/application/cubit/user_cubit.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConversationCubit>().getConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationCubit, ConversationState>(
      builder: (context, state) {
        final userState = context.watch<UserCubit>().state;
        return InAppStatusWrapper(
          hasContent: state.conversations.isNotEmpty,
          isLoading: state.isLoading,
          errorMessage: state.errorMessage,
          loadingText: 'Loading conversations...',
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.conversations.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              indent: 76,
              color: context.colorScheme.outline.withAlpha(30),
            ),
            itemBuilder: (context, index) {
              final conversation = state.conversations[index];
              final otherUserId = conversation.participantIds
                  .where((id) => id != state.currentUserId)
                  .firstOrNull;
              final otherUser = otherUserId == null
                  ? null
                  : userState.usersById[otherUserId];
              final isGroup = conversation.type == ConversationType.group;
              final title = isGroup
                  ? (conversation.name.trim().isEmpty
                        ? 'Unnamed group'
                        : conversation.name)
                  : (otherUser?.username ?? 'Unknown user');
              final avatarLabel = title.characters.first.toUpperCase();
              final avatarUrl = isGroup
                  ? conversation.avatarUrl
                  : otherUser?.avatarUrl;
              final unreadCount =
                  conversation.unreadCountMap[state.currentUserId]?.count ?? 0;
              final isUnread = unreadCount > 0;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: context.colorScheme.surfaceContainerHighest,
                  backgroundImage: avatarUrl?.isNotEmpty == true
                      ? NetworkImage(avatarUrl!)
                      : null,
                  child: avatarUrl?.isNotEmpty == true
                      ? null
                      : Text(
                          avatarLabel,
                          style: context.textTheme.titleMedium,
                        ),
                ),
                title: Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  unreadCount > 1
                      ? '$unreadCount new messages'
                      : conversation.lastMessage?.type == MessageType.text
                      ? conversation.lastMessage?.text ?? ''
                      : conversation.lastMessage?.type == MessageType.image
                      ? 'Send a image'
                      : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isUnread
                        ? context.colorScheme.onSurface
                        : context.colorScheme.outline,
                    fontWeight: isUnread ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
                onTap: () => context.push('${AppRoutes.chat}/${conversation.id}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      conversation.lastMessage?.createdAt == null
                          ? ''
                          : DateFormatter.formatMessageTime(
                              conversation.lastMessage!.createdAt.toDate(),
                            ),
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}
