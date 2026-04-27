import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_state.dart';
import 'package:social_app/features/conversation/data/datasources/local/conversation_local_data_source.dart';
import 'package:social_app/features/conversation/data/mappers/conversation_mapper.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/entites/unread_count.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversations_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/watch_conversations_usecase.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final GetConversationsUsecase _getConversationsUsecase;
  final ConversationLocalDataSource _conversationLocalDataSource;
  final WatchConversationsUsecase _watchConversationsUsecase;

  StreamSubscription<List<ConversationEntity>>? _conversationSubscription;

  ConversationCubit({
    required GetConversationsUsecase getConversationsUsecase,
    required ConversationLocalDataSource conversationLocalDataSource,
    required WatchConversationsUsecase watchConversationsUsecase,
  }) : _watchConversationsUsecase = watchConversationsUsecase,
       _conversationLocalDataSource = conversationLocalDataSource,
       _getConversationsUsecase = getConversationsUsecase,
       super(ConversationState.initial());

  Future<void> initializeSession(String currentUserId) async {
    emit(state.copyWith(currentUserId: currentUserId, clearError: true));
    await _loadCachedConversations(currentUserId);
    await watchConversation(currentUserId);
  }

  Future<void> getConversations() async {
    if (state.currentUserId.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

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
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
          clearError: false,
        ),
      );
    }
  }

  Future<void> updateNewMessageConversationLocal(
    MessageEntity newMessage,
  ) async {
    try {
      final updatedConversations = state.conversations.map((c) {
        if (c.id == newMessage.conversationId) {
          final otherUserId = c.participantIds.firstWhere(
            (id) => id != newMessage.senderId,
          );
          final newUnreadCountMap = Map<String, UnreadCount>.from(
            c.unreadCountMap,
          );
          // Increment the other user's unread count
          final currentUnread = newUnreadCountMap[otherUserId]?.count ?? 0;
          newUnreadCountMap[otherUserId] = UnreadCount(
            count: currentUnread + 1,
          );
          // Reset sender's unread count to 0
          newUnreadCountMap[newMessage.senderId] = const UnreadCount(count: 0);

          return c.copyWith(
            lastMessage: c.lastMessage?.copyWith(
              id: newMessage.id,
              senderId: newMessage.senderId,
              type: newMessage.type,
              text: newMessage.text,
              mediaUrl: newMessage.mediaUrl,
              mediaType: newMessage.mediaType,
              isDeleted: newMessage.isDeleted,
              createdAt: newMessage.createdAt,
            ),
            unreadCountMap: newUnreadCountMap,
          );
        }

        return c;
      }).toList();

      updatedConversations.sort((a, b) {
        final aTime = a.lastMessage?.createdAt ?? a.createdAt;
        final bTime = b.lastMessage?.createdAt ?? b.createdAt;
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
              final updatedMap = Map<String, UnreadCount>.from(c.unreadCountMap)
                ..[currentUserId] = const UnreadCount(count: 0);
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

  Future<void> _loadCachedConversations(String currentUserId) async {
    try {
      final cachedConversationsModels = await _conversationLocalDataSource
          .getCachedConversations(currentUserId);

      if (cachedConversationsModels.isEmpty) {
        return;
      }

      final cachedConversations = cachedConversationsModels
          .map(ConversationMapper.toEntity)
          .toList();

      emit(state.copyWith(conversations: cachedConversations));
    } catch (_) {
      // Ignore cache bootstrap failures and continue to remote fetch.
    }
  }

  int getTotalUnreadCount(ConversationState state) {
    if (state.currentUserId.isEmpty) return 0;

    return state.conversations.fold<int>(
      0,
      (total, conversation) {
        final unreadCount =
            conversation.unreadCountMap[state.currentUserId]?.count ?? 0;
        return total + (unreadCount > 0 ? 1 : 0);
      },
    );
  }

  Future<void> watchConversation(String currentUserId) async {
    await _conversationSubscription?.cancel();

    emit(state.copyWith());

    _conversationSubscription = _watchConversationsUsecase(currentUserId)
        .listen((conversations) {
          emit(state.copyWith(clearError: true, conversations: conversations));
        });
  }

  @override
  Future<void> close() async {
    await _conversationSubscription?.cancel();
    return super.close();
  }

  void clear() {
    emit(ConversationState.initial());
  }
}
