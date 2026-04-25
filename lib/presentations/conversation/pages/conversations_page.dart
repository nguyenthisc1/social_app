import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/core/routes/app_routes.dart';
import 'package:social_app/core/utils/extensions.dart';
import 'package:social_app/core/widgets/error_view.dart';
import 'package:social_app/core/widgets/loading_indicator.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_state.dart';
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
      _fetchConversationUsers();
    });
  }

  void _fetchConversationUsers() {
    final userCubit = context.read<UserCubit>();
    final conversationState = context.read<ConversationCubit>().state;
    final currentUserId = userCubit.state.profile?.id;

    if (currentUserId == null || conversationState.conversations.isEmpty) {
      return;
    }

    final participantIds = conversationState.conversations
        .expand((conversation) => conversation.participantIds)
        .where((memberId) => memberId != currentUserId)
        .toSet()
        .toList();

    if (participantIds.isNotEmpty) {
      userCubit.fetchUsersByIds(participantIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConversationCubit, ConversationState>(
      listenWhen: (previous, current) =>
          previous.conversations != current.conversations ||
          previous.errorMessage != current.errorMessage,

      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          context.showSnackBar(state.errorMessage!, isError: true);
        }

        _fetchConversationUsers();
      },

      builder: (context, state) {
        final userState = context.watch<UserCubit>().state;

        if (state.isLoading) {
          return const LoadingIndicator();
        }

        if (state.errorMessage != null) {
          return ErrorView(message: state.errorMessage);
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.conversations.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            indent: 76,
            color: context.colorScheme.outline.withAlpha(30),
          ),
          itemBuilder: (context, index) {
            final conversation = state.conversations[index];
            // Other User conversation
            final otherUserId = conversation.participantIds
                .where((id) => id != state.currentUserId)
                .firstOrNull;
            final otherUser = otherUserId == null
                ? null
                : userState.usersById[otherUserId];
            final title = otherUser?.username ?? 'Unknown user';
            final avatarLabel = title.isNotEmpty
                ? title.characters.first.toUpperCase()
                : '?';
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
                child: Text(avatarLabel, style: context.textTheme.titleMedium),
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
                    ? conversation.lastMessage?.text ?? ""
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
                        : _formatMessageTime(
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
        );
      },
    );
  }

  String _formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    }

    if (difference.inDays < 1) {
      return '${difference.inHours}h';
    }

    return '${difference.inDays}d';
  }
}
