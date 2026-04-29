import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/core/widgets/in_app_notification_banner.dart';
import 'package:social_app/core/widgets/internet_status_banner.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_state.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_type.dart';
import 'package:social_app/features/message/domain/entites/message_type.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_bloc.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_event.dart';
import 'package:social_app/features/notification/domain/entities/in_app_notification_entity.dart';
import 'package:social_app/features/notification/domain/entities/notification_types.dart';
import 'package:social_app/features/user/application/cubit/user_cubit.dart';

class AppNotification extends StatefulWidget {
  final Widget child;

  const AppNotification({super.key, required this.child});

  @override
  State<AppNotification> createState() => _AppNotificationState();
}

class _AppNotificationState extends State<AppNotification> {
  final Map<String, String?> _lastMessageIds = {};

  Map<String, String?>? _resolveConversation(
    BuildContext context,
    ConversationEntity conversation,
    String currentUserId,
  ) {
    if (conversation.type == ConversationType.group) {
      return {
        'avatarUrl': conversation.avatarUrl,
        'conversationName': conversation.name,
      };
    }

    final otherUserId = conversation.participantIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );

    if (otherUserId.isEmpty) {
      return {
        'avatarUrl': conversation.avatarUrl,
        'conversationName': conversation.name,
      };
    }

    final otherUser = context.read<UserCubit>().getCachedUser(otherUserId);
    return {
      'avatarUrl': otherUser?.avatarUrl ?? conversation.avatarUrl,
      'conversationName': otherUser?.username ?? conversation.name,
    };
  }

  String _bodyNotification(ConversationEntity conversation) {
    switch (conversation.lastMessage!.type) {
      case MessageType.text:
        return conversation.lastMessage?.text.toString() ?? "Send message";
      case MessageType.image:
        return "Sent a photo";
      default:
        return "New message";
    }
  }

  void _handleConversationUpdates(
    BuildContext context,
    ConversationState state,
  ) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    for (final conversation in state.conversations) {
      if (currentRoute == AppRoutes.conversations) {
        continue;
      }

      final lastMessage = conversation.lastMessage;

      if (lastMessage == null) continue;

      // check its a new message
      final previousLastMessageId = _lastMessageIds[conversation.id];

      final isNewMessage =
          previousLastMessageId != null &&
          previousLastMessageId != lastMessage.id;

      if (isNewMessage && lastMessage.senderId != state.currentUserId) {
        final resConversation = _resolveConversation(
          context,
          conversation,
          state.currentUserId,
        );

        final isGroup = conversation.type == ConversationType.group;
        final title = isGroup
            ? (conversation.name.trim().isEmpty
                  ? 'Unnamed group'
                  : conversation.name)
            : (resConversation?['conversationName'] ?? 'Unknown user');
        final avatarLabel = title.characters.first.toUpperCase();
        debugPrint('Check OK');

        context.read<InAppNotificationBloc>().add(
          InAppNotificationReceived(
            InAppNotificationEntity(
              id: lastMessage.id,
              type: NotificationType.newMessage,
              priority: NotificationPriority.normal,
              title: title,
              body: _bodyNotification(conversation),
              payload: {
                'conversationId': conversation.id,
                'conversationName': avatarLabel,
              },
              createdAt: lastMessage.createdAt.toDate(),
              isRead: false,
              avatarUrl: resConversation?['avatarUrl'],
            ),
          ),
        );
      }

      _lastMessageIds[conversation.id] = lastMessage.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: AppSize.lg,
          left: 0,
          right: 0,
          child: const InternetStatusBanner(),
        ),
        BlocListener<ConversationCubit, ConversationState>(
          listenWhen: (previous, current) =>
              previous.conversations != current.conversations,
          listener: (BuildContext context, state) {
            _handleConversationUpdates(context, state);
          },
          child: const InAppNotificationBanner(),
        ),
        widget.child,
      ],
    );
  }
}
