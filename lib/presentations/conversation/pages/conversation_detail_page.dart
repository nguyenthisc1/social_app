import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/utils/extensions.dart';
import 'package:social_app/core/widgets/error_view.dart';
import 'package:social_app/core/widgets/in_app_status_wrapper.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_detail_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_detail_state.dart';
import 'package:social_app/features/conversation/domain/entites/unread_count.dart';
import 'package:social_app/features/message/application/cubit/meesage_cubit.dart';
import 'package:social_app/features/message/application/cubit/message_state.dart';
import 'package:social_app/features/message/domain/entites/message_delivery_status.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/entites/message_type.dart';
import 'package:social_app/features/user/application/cubit/user_cubit.dart';
import 'package:social_app/presentations/conversation/widgets/chat_app_bar.dart';
import 'package:social_app/presentations/conversation/widgets/chat_input_bar.dart';
import 'package:social_app/presentations/conversation/widgets/chat_message_list.dart';

class ConversationDetailPage extends StatefulWidget {
  const ConversationDetailPage({super.key, required this.conversationId});

  final String conversationId;

  @override
  State<ConversationDetailPage> createState() => _ConversationDetailPageState();
}

class _ConversationDetailPageState extends State<ConversationDetailPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;

  String? get currentUserId => context.read<UserCubit>().state.profile?.id;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onInputChanged);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => updateUnreadCountConversation(),
    );
  }

  @override
  void dispose() {
    _inputController
      ..removeListener(_onInputChanged)
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    final hasText = _inputController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    final newMessage = MessageEntity(
      clientMessageId: tempId,
      id: tempId,
      conversationId: widget.conversationId,
      text: text,
      senderId: currentUserId!,
      type: MessageType.text,
      status: MessageDeliveryStatus.sending,
      createdAt: Timestamp.now(),
      reactions: {},
    );

    context.read<MessageCubit>().sendMessage(
      conversationId: widget.conversationId,
      message: newMessage,
      currentUserId: currentUserId!,
    );

    context.read<ConversationCubit>().updateNewMessageConversationLocal(
      newMessage,
    );

    setState(() => _inputController.clear());
  }

  void updateUnreadCountConversation() {
    final conversationState = context.read<ConversationDetailCubit>().state;

    if (currentUserId == null || conversationState.conversation == null) {
      return;
    }

    final newUnreadCount = Map<String, UnreadCount>.from(
      conversationState.conversation!.unreadCountMap,
    );

    if (newUnreadCount[currentUserId!] != null) {
      newUnreadCount[currentUserId!] = newUnreadCount[currentUserId!]!.copyWith(
        count: 0,
        lastReadAt: Timestamp.now(),
        lastReadMessageId: context
            .read<ConversationDetailCubit>()
            .state
            .conversation
            ?.lastMessage
            ?.id,
      );
    }

    final updatedConversation = conversationState.conversation!.copyWith(
      unreadCountMap: newUnreadCount,
    );

    context.read<ConversationDetailCubit>().updateUnreadCountConversation(
      updatedConversation,
    );

    context.read<ConversationCubit>().updateLocalUnreadCountConversation(
      currentUserId!,
      updatedConversation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConversationDetailCubit, ConversationDetailState>(
      listenWhen: (previous, current) =>
          previous.conversation?.id != current.conversation?.id ||
          previous.currentUserId != current.currentUserId ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          context.showSnackBar(state.errorMessage!, isError: true);
        }
        updateUnreadCountConversation();
      },
      builder: (context, detailState) {
        if (detailState.errorMessage != null) {
          return ErrorView(message: detailState.errorMessage);
        }

        final otherUserId = detailState.conversation?.participantIds
            .firstWhere((id) => id != currentUserId, orElse: () => '');
        final otherUser =
            context.watch<UserCubit>().state.usersById[otherUserId];

        return BlocConsumer<MessageCubit, MessageState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              context.showSnackBar(state.errorMessage!, isError: true);
            }
          },
          builder: (context, messageState) {
            return Scaffold(
              backgroundColor: context.theme.colorScheme.surface,
              appBar: ChatAppBar(
                username: otherUser?.username ?? '',
                avatarUrl: otherUser?.avatarUrl,
              ),
              bottomNavigationBar: ChatInputBar(
                controller: _inputController,
                hasText: _hasText,
                onSend: _sendMessage,
              ),
              body: InAppStatusWrapper(
                hasContent: messageState.messages.isNotEmpty,
                isLoading: messageState.isLoading,
                child: ChatMessageList(
                  messages: messageState.messages,
                  currentUserId: currentUserId,
                  scrollController: _scrollController,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
