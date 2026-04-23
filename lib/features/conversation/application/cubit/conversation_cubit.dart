import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/di/service_locator.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_state.dart';
import 'package:social_app/features/conversation/domain/usecases/create_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversations_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/update_conversation_usecase.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/user/application/cubit/user_cubit.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final GetConversationUsecase _getConversationUsecase;
  final GetConversationsUsecase _getConversationsUsecase;
  final CreateConversationUsecase _createConversationUsecase;
  final UpdateConversationsUsecase _updateConversationsUsecase;

  ConversationCubit({
    required GetConversationUsecase getConversationUsecase,
    required GetConversationsUsecase getConversationsUsecase,
    required CreateConversationUsecase createConversationUsecase,
    required UpdateConversationsUsecase updateConversationsUsecase,
  }) : _getConversationUsecase = getConversationUsecase,
       _getConversationsUsecase = getConversationsUsecase,
       _createConversationUsecase = createConversationUsecase,
       _updateConversationsUsecase = updateConversationsUsecase,
       super(ConversationState.initial());

  Future<void> loadConversations() async {
    final currentUserResult = sl<UserCubit>().state;

    if (currentUserResult.profile != null) {
      emit(state.copyWith(currentUserId: currentUserResult.profile!.id));
      await getConversations();
    }
  }

  Future<void> getConversations() async {
    emit(state.copyWith(isLoading: true));
    try {
      final conversaions = await _getConversationsUsecase(state.currentUserId);
      final otherUserIds = conversaions
          .expand((conversation) => conversation.memberIds)
          .where((id) => id != state.currentUserId)
          .toSet()
          .toList();

      await sl<UserCubit>().preloadUsers(otherUserIds);

      emit(
        state.copyWith(
          isLoading: false,
          clearError: true,
          conversations: conversaions,
        ),
      );
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString(), clearError: false));
    }
  }

  Future<void> updateNewMessageConversationLocal(
    MessageEntity newMessage,
  ) async {
    try {
      final updatedConversations = state.conversations.map((c) {
        if (c.id == newMessage.conversationId) {
          final otherUserId = c.memberIds.firstWhere(
            (id) => id != newMessage.senderId,
          );
          final newUnreadCountMap = Map<String, int>.from(c.unreadCountMap);
          newUnreadCountMap[otherUserId] =
              (newUnreadCountMap[otherUserId] ?? 0) + 1;
          newUnreadCountMap[newMessage.senderId] = 0;

          return c.copyWith(
            lastMessage: newMessage.text,
            lastMessageAt: newMessage.createdAt,
            lastMessageType: newMessage.type,
            lastSenderId: newMessage.senderId,
            unreadCountMap: newUnreadCountMap,
          );
        }

        return c;
      }).toList();

      updatedConversations.sort((a, b) {
        final aTime = a.lastMessageAt ?? a.createdAt;
        final bTime = b.lastMessageAt ?? b.createdAt;
        return bTime.compareTo(aTime);
      });

      emit(
        state.copyWith(
          isLoading: false,
          clearError: true,
          conversations: updatedConversations,
        ),
      );
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString(), clearError: false));
    }
  }
}
