import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_state.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/usecases/create_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversations_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/update_conversation_usecase.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';

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

  Future<void> loadConversationsForUser(String currentUserId) async {
    emit(state.copyWith(currentUserId: currentUserId));
    await getConversations();
  }

  Future<void> getConversations() async {
    if (state.currentUserId.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true));
    try {
      final conversations = await _getConversationsUsecase(state.currentUserId);

      emit(
        state.copyWith(
          isLoading: false,
          clearError: true,
          conversations: conversations,
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

  void updateLocalUnreadCountConversation(
    String currentUserId,
    ConversationEntity conversation,
  ) {
    try {
      emit(
        state.copyWith(
          conversations: state.conversations.map((c) {
            if (c.id == conversation.id) {
              final updatedMap = Map<String, int>.from(c.unreadCountMap)
                ..[currentUserId] = 0;
              return c.copyWith(unreadCountMap: updatedMap);
            }
            return c;
          }).toList(),
        ),
      );
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString(), clearError: false));
    }
  }

  int getTotalUnreadCount(ConversationState state) {
    if (state.currentUserId.isEmpty) return 0;

    return state.conversations.fold<int>(
      0,
      (total, conversation) =>
          total + (conversation.unreadCountMap[state.currentUserId] ?? 0),
    );
  }

  void clear() {
    emit(ConversationState.initial());
  }
}
