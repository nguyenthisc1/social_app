import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/utils/helper.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_detail_state.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/update_conversation_usecase.dart';

class ConversationDetailCubit extends Cubit<ConversationDetailState> {
  final GetConversationUsecase _getConversationUsecase;
  final UpdateConversationsUsecase _updateConversationsUsecase;

  ConversationDetailCubit({
    required GetConversationUsecase getConversationUsecase,
    required UpdateConversationsUsecase updateConversationsUsecase,
  }) : _updateConversationsUsecase = updateConversationsUsecase,
       _getConversationUsecase = getConversationUsecase,
       super(ConversationDetailState.initial());

  Future<void> getConversation(String conversationId) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final conversation = await _getConversationUsecase(conversationId);
      emit(
        state.copyWith(
          isLoading: false,
          clearError: true,
          conversation: conversation,
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

  Future<void> updateUnreadCountConversation(
    ConversationEntity conversation,
  ) async {
    try {
      final oldUnreadCountMap = state.conversation?.unreadCountMap;
      final newUnreadCountMap = conversation.unreadCountMap;

      if (oldUnreadCountMap != null &&
          Helper.mapsEqual(oldUnreadCountMap, newUnreadCountMap)) {
        // Unread count unchanged, skip update
        return;
      }

      final newConversation = await _updateConversationsUsecase(conversation);

      emit(
        state.copyWith(
          isLoading: false,
          clearError: true,
          conversation: newConversation,
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

  void clear() {
    emit(ConversationDetailState.initial());
  }
}
