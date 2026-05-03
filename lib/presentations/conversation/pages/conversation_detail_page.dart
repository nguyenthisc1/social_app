import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app/core/utils/extensions.dart';
import 'package:social_app/core/widgets/error_view.dart';
import 'package:social_app/core/widgets/expanded_modal_bottom_sheet.dart';
import 'package:social_app/core/widgets/gallery_grid_select.dart';
import 'package:social_app/core/widgets/side_effect_status_wrapper.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_detail_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_detail_state.dart';
import 'package:social_app/features/conversation/application/cubit/gallery_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/gallery_state.dart';
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
  const ConversationDetailPage({
    super.key,
    required this.conversationId,
    this.onSelectionChanged,
  });

  final String conversationId;
  final ValueChanged<List<AssetEntity>>? onSelectionChanged;

  @override
  State<ConversationDetailPage> createState() => _ConversationDetailPageState();
}

class _ConversationDetailPageState extends State<ConversationDetailPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _hasText = false;
  bool _isGalleryOpen = false;

  String? get _currentUserId => context.read<UserCubit>().state.profile?.id;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_handleInputChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateUnreadCount());
  }

  @override
  void dispose() {
    _inputController
      ..removeListener(_handleInputChange)
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleInputChange() {
    final hasText = _inputController.text.trim().isNotEmpty;
    if (_hasText != hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    final userId = _currentUserId;
    if (text.isEmpty || userId == null) return;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final message = MessageEntity(
      clientMessageId: tempId,
      id: tempId,
      conversationId: widget.conversationId,
      text: text,
      senderId: userId,
      type: MessageType.text,
      status: MessageDeliveryStatus.sending,
      createdAt: Timestamp.now(),
      reactions: {},
    );

    context.read<MessageCubit>().sendMessage(
      conversationId: widget.conversationId,
      message: message,
      currentUserId: userId,
    );

    context.read<ConversationCubit>().updateNewMessageConversationLocal(
      message,
    );

    setState(_inputController.clear);
  }

  void _updateUnreadCount() {
    final userId = _currentUserId;
    final conversationState = context.read<ConversationDetailCubit>().state;
    final conversation = conversationState.conversation;
    if (userId == null || conversation == null) return;

    final newUnreadCount = Map<String, UnreadCount>.from(
      conversation.unreadCountMap,
    );
    if (newUnreadCount[userId] != null) {
      newUnreadCount[userId] = newUnreadCount[userId]!.copyWith(
        count: 0,
        lastReadAt: Timestamp.now(),
        lastReadMessageId: conversation.lastMessage?.id,
      );
    }

    final updatedConversation = conversation.copyWith(
      unreadCountMap: newUnreadCount,
    );

    context.read<ConversationDetailCubit>().updateUnreadCountConversation(
      updatedConversation,
    );
    context.read<ConversationCubit>().updateLocalUnreadCountConversation(
      userId,
      updatedConversation,
    );
  }

  double get _bottomInset => _isGalleryOpen ? context.screenHeight * 0.5 : 12;

  Future<void> _openGalleryModalBottomSheet() async {
    final galleryCubit = context.read<GalleryCubit>();
    if (galleryCubit.state.assets.isEmpty) {
      await galleryCubit.initialize();
    }

    if (!mounted) return;

    if (!galleryCubit.state.hasPermission) {
      context.showSnackBar('Gallery permission is required.', isError: true);
      return;
    }

    setState(() => _isGalleryOpen = true);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: galleryCubit,
        child: const ExpandedModalBottomSheet(child: GalleryGridSelect()),
      ),
    );

    if (!mounted) return;

    setState(() => _isGalleryOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GalleryCubit, GalleryState>(
      listenWhen: (previous, current) =>
          previous.selectedIds != current.selectedIds ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          context.showSnackBar(state.errorMessage!, isError: true);
        }
        widget.onSelectionChanged?.call(context.read<GalleryCubit>().getSelectedAssets());
      },
      child: BlocConsumer<ConversationDetailCubit, ConversationDetailState>(
        listenWhen: (previous, current) =>
            previous.conversation?.id != current.conversation?.id ||
            previous.currentUserId != current.currentUserId ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          }
          _updateUnreadCount();
        },
        builder: (context, detailState) {
          if (detailState.errorMessage != null) {
            return ErrorView(message: detailState.errorMessage);
          }

          final otherUserId = detailState.conversation?.participantIds.firstWhere(
            (id) => id != _currentUserId,
            orElse: () => '',
          );
          final otherUser = context
              .watch<UserCubit>()
              .state
              .usersById[otherUserId];

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
                body: SideEffectStatusWrapper(
                  hasContent: messageState.messages.isNotEmpty,
                  isLoading: messageState.isLoading,
                  child: SafeArea(
                    bottom: false,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 230),
                      curve: Curves.ease,
                      margin: EdgeInsets.only(bottom: _bottomInset),
                      child: Stack(
                        children: [
                          ChatMessageList(
                            messages: messageState.messages,
                            currentUserId: _currentUserId ?? '',
                            scrollController: _scrollController,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: ChatInputBar(
                              controller: _inputController,
                              hasText: _hasText,
                              onAttach: _openGalleryModalBottomSheet,
                              onSend: _sendMessage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
