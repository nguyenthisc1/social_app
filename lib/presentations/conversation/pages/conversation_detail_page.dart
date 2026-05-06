import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app/app/di/service_locator.dart';
import 'package:social_app/core/data/cloudinary/cloudinary_service.dart';
import 'package:social_app/core/domain/exceptions/exception_base.dart';
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
    this.onSendGallery,
  });

  final String conversationId;
  final ValueChanged<List<AssetEntity>>? onSelectionChanged;
  final Future<void> Function(List<AssetEntity>)? onSendGallery;

  @override
  State<ConversationDetailPage> createState() => _ConversationDetailPageState();
}

class _ConversationDetailPageState extends State<ConversationDetailPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _hasText = false;
  bool _isGalleryOpen = false;
  double get _bottomInset => _isGalleryOpen ? context.screenHeight * 0.5 : 12;

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

  Future<void> _sendTextMessage() async {
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

  Future<void> _updateUnreadCount() async {
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
        child: ExpandedModalBottomSheet(
          child: GalleryGridSelect(onSend: _handleSendGallery),
        ),
      ),
    );

    if (!mounted) return;

    setState(() => _isGalleryOpen = false);
  }

  Future<void> _handleSendGallery(List<AssetEntity> selectedAssets) async {
    final galleryCubit = context.read<GalleryCubit>();
    final navigator = Navigator.of(context);
    try {
      final onSendGallery = widget.onSendGallery;
      if (onSendGallery != null) {
        await onSendGallery(selectedAssets);
      } else {
        await _sendImagesMessages(selectedAssets);
      }

      galleryCubit.clearSelection();
      if (mounted) {
        navigator.pop();
      }
    } catch (error) {
      if (!mounted) return;
      final message = switch (error) {
        ExceptionBase exception => exception.userMessage,
        _ => error.toString(),
      };
      context.showSnackBar(message, isError: true);
    }
  }

  Future<List<String>> _getLocalSelectedAssetPaths(
    List<AssetEntity> selectedAssets,
  ) async {
    final List<String> paths = [];
    for (final asset in selectedAssets) {
      final file = await asset.file;
      if (file != null) {
        paths.add(file.path);
      }
    }
    return paths;
  }

  Future<void> _sendImagesMessages(List<AssetEntity> selectedAssets) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw StateError('Current user is required to send gallery images.');
    }

    final localAssetPaths = await _getLocalSelectedAssetPaths(selectedAssets);
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final optimisticMessage = await _showOptimisticGalleryMessage(
      tempId: tempId,
      userId: userId,
      localAssetPaths: localAssetPaths,
    );
    final uploadedUrls = await _uploadGalleryImages(
      localAssetPaths: localAssetPaths,
      tempId: tempId,
      selectedAssets: selectedAssets,
    );

    if (uploadedUrls == null || uploadedUrls.isEmpty) {
      return; // Error is already thrown in _uploadGalleryImages.
    }

    final messageCubit = context.read<MessageCubit>();
    final conversationCubit = context.read<ConversationCubit>();
    final sentMessage = optimisticMessage.copyWith(
      mediaUrls: uploadedUrls,
      status: MessageDeliveryStatus.sending,
    );

    await messageCubit.sendMessage(
      conversationId: widget.conversationId,
      message: sentMessage,
      currentUserId: userId,
    );

    conversationCubit.updateNewMessageConversationLocal(sentMessage);

    // if (uploadedUrls.length != selectedAssets.length && mounted) {
    //   context.showSnackBar(
    //     'Uploaded ${uploadedUrls.length}/${selectedAssets.length} images.',
    //   );
    // }
  }

  Future<MessageEntity> _showOptimisticGalleryMessage({
    required String tempId,
    required String userId,
    required List<String> localAssetPaths,
  }) async {
    final messageCubit = context.read<MessageCubit>();
    final conversationCubit = context.read<ConversationCubit>();

    final optimisticMessage = MessageEntity(
      clientMessageId: tempId,
      id: tempId,
      conversationId: widget.conversationId,
      senderId: userId,
      type: MessageType.image,
      status: MessageDeliveryStatus.sending,
      reactions: const {},
      mediaUrls: localAssetPaths,
      mediaType: MessageType.image.name,
      createdAt: Timestamp.now(),
    );

    await messageCubit.sendMessageLocal(
      conversationId: widget.conversationId,
      message: optimisticMessage,
      currentUserId: userId,
    );
    conversationCubit.updateNewMessageConversationLocal(optimisticMessage);

    return optimisticMessage;
  }

  Future<List<String>?> _uploadGalleryImages({
    required List<String> localAssetPaths,
    required String tempId,
    required List<AssetEntity> selectedAssets,
  }) async {
    final cloudinaryService = sl<CloudinaryService>();
    final messageCubit = context.read<MessageCubit>();
    final uploadedUrls = <String>[];
    Object? lastError;
    for (final path in localAssetPaths) {
      try {
        final uploaded = await cloudinaryService.uploadMedia(path);
        uploadedUrls.add(uploaded.url);
      } catch (error) {
        lastError = error;
      }
    }

    if (uploadedUrls.isEmpty && lastError != null) {
      await messageCubit.markMessageFailed(
        conversationId: widget.conversationId,
        clientMessageId: tempId,
      );
      throw lastError;
    }

    if (uploadedUrls.isEmpty) {
      throw StateError('No images were uploaded.');
    }

    return uploadedUrls;
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
        widget.onSelectionChanged?.call(
          context.read<GalleryCubit>().getSelectedAssets(),
        );
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

          final otherUserId = detailState.conversation?.participantIds
              .firstWhere((id) => id != _currentUserId, orElse: () => '');
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
                    bottom: true,
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
                              onSend: _sendTextMessage,
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
