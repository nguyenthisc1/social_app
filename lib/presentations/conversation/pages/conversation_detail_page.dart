import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:social_app/core/theme/app_size.dart';
import 'package:social_app/core/utils/extensions.dart';
import 'package:social_app/core/widgets/error_view.dart';
import 'package:social_app/core/widgets/loading_indicator.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_detail_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_detail_state.dart';
import 'package:social_app/features/message/application/cubit/meesage_cubit.dart';
import 'package:social_app/features/message/application/cubit/message_state.dart';
import 'package:social_app/features/message/domain/entites/message_delivery_status.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/user/application/cubit/user_cubit.dart';
import 'package:social_app/presentations/conversation/widgets/message_bubble_widget.dart';

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

  void _scrollToBottom({bool animated = false}) {
    if (!_scrollController.hasClients) return;
    if (animated) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch.toString()}';

    final newMessage = MessageEntity(
      clientMessageId: tempId,
      id: tempId,
      conversationId: widget.conversationId,
      text: text,
      senderId: currentUserId!,
      type: 'text',
      status: MessageDeliveryStatus.sending,
      createdAt: Timestamp.now(),
    );

    context.read<MessageCubit>().sendMessage(
      conversationId: widget.conversationId,
      message: newMessage,
      currentUserId: currentUserId!,
    );

    context.read<ConversationCubit>().updateNewMessageConversationLocal(
      newMessage,
    );

    setState(() {
      _inputController.clear();
    });

    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => _scrollToBottom(animated: true),
    // );
  }

  void updateUnreadCountConversation() {
    final conversationState = context.read<ConversationDetailCubit>().state;

    if (currentUserId == null || conversationState.conversation == null) {
      return;
    }
    print('state ${conversationState.currentUserId}');

    final newUnreadCount = Map<String, int>.from(
      conversationState.conversation!.unreadCountMap,
    );

    newUnreadCount[currentUserId!] = 0;

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

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConversationDetailCubit, ConversationDetailState>(
      listenWhen: (previous, current) =>
          previous.conversation?.id != current.conversation?.id ||
          previous.currentUserId != current.currentUserId ||
          previous.errorMessage != current.errorMessage,

      listener: (BuildContext context, state) {
        if (state.errorMessage != null) {
          context.showSnackBar(state.errorMessage!, isError: true);
        }

        updateUnreadCountConversation();
      },
      builder: (BuildContext context, state) {
        if (state.isLoading) {
          return const LoadingIndicator();
        }

        if (state.errorMessage != null) {
          return ErrorView(message: state.errorMessage);
        }

        return BlocConsumer<MessageCubit, MessageState>(
          listener: (BuildContext context, MessageState state) {
            if (state.errorMessage != null) {
              context.showSnackBar(state.errorMessage!, isError: true);
            }
          },
          builder: (BuildContext context, state) {
            return Scaffold(
              backgroundColor: context.theme.colorScheme.surface,
              appBar: _buildAppBar(context.theme),
              bottomNavigationBar: _buildInputBar(context.theme),
              body: _buildMessageList(context.theme, state.messages),
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    final otherUserId = context
        .read<ConversationDetailCubit>()
        .state
        .conversation
        ?.memberIds
        .firstWhere((id) => id != currentUserId);
    final otherUser = context.watch<UserCubit>().state.usersById[otherUserId];

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowLeft),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  'A',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              // Positioned(
              //   right: 0,
              //   bottom: 0,
              //   child: Container(
              //     width: 10,
              //     height: 10,
              //     decoration: BoxDecoration(
              //       color: const Color(0xFF4CAF50),
              //       shape: BoxShape.circle,
              //       border: Border.all(
              //         color: theme.colorScheme.surface,
              //         width: 1.5,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(width: AppSize.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  otherUser?.username ?? "",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                // Text(
                //   'Online',
                //   style: theme.textTheme.labelSmall?.copyWith(
                //     color: const Color(0xFF4CAF50),
                //     fontSize: 11,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.phone),
          onPressed: () {},
          tooltip: 'Voice call',
        ),
        IconButton(
          icon: const Icon(LucideIcons.video),
          onPressed: () {},
          tooltip: 'Video call',
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildMessageList(ThemeData theme, List<MessageEntity> messages) {
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
      controller: _scrollController,
      padding: const EdgeInsets.only(top: AppSize.sm),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMine = message.senderId == currentUserId;
        final isLastFromSender =
            index == messages.length - 1 ||
            messages[index + 1].senderId != message.senderId;

        final currentMessageDay = message.createdAt.toDate();
        DateTime? nextOlderMessageDay;
        if (index < messages.length - 1) {
          nextOlderMessageDay = messages[index + 1].createdAt.toDate();
        }

        bool showDateDivider = false;

        if (index == messages.length - 1) {
          showDateDivider = true;
        } else if (!_isSameDay(currentMessageDay, nextOlderMessageDay!)) {
          showDateDivider = true;
        }

        return Column(
          children: [
            if (showDateDivider) _buildDateDivider(theme, currentMessageDay),
            MessageBubbleWidget(
              message: message,
              isMine: isMine,
              // showAvatar: !isMine && isLastFromSender,
              showAvatar: !isMine,
              timeLabel: _formatTime(currentMessageDay),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateDivider(ThemeData theme, DateTime date) {
    final now = DateTime.now();
    String label;

    if (_isSameDay(date, now)) {
      label = 'Today';
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      label = 'Yesterday';
    } else {
      label = '${date.day}/${date.month}/${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSize.md),
      child: Row(
        children: [
          const SizedBox(width: AppSize.lg),
          Expanded(
            child: Divider(color: theme.colorScheme.outline.withAlpha(40)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.sm),
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: theme.colorScheme.outline.withAlpha(40)),
          ),
          const SizedBox(width: AppSize.lg),
        ],
      ),
    );
  }

  Widget _buildInputBar(ThemeData theme) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.sm,
          vertical: AppSize.sm,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.colorScheme.outline.withAlpha(30)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                LucideIcons.paperclip,
                color: theme.colorScheme.outline,
              ),
              onPressed: () {},
              tooltip: 'Attach file',
            ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(
                    AppSize.borderRadiusXLarge,
                  ),
                ),
                child: TextField(
                  controller: _inputController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Message…',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSize.md,
                      vertical: AppSize.sm + 2,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSize.xs),
            SizedBox(
              width: 42,
              height: 42,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: _hasText
                    ? _SendButton(
                        key: const ValueKey('send'),
                        onTap: _sendMessage,
                      )
                    : _EmojiButton(key: const ValueKey('emoji'), onTap: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _SendButton extends StatelessWidget {
  const _SendButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          LucideIcons.sendHorizontal,
          size: AppSize.iconSmall + 2,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class _EmojiButton extends StatelessWidget {
  const _EmojiButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: onTap,
      icon: Icon(LucideIcons.smile, color: theme.colorScheme.outline),
      tooltip: 'Emoji',
    );
  }
}
