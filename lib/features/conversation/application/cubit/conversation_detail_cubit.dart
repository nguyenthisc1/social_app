import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_detail_state.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversation_usecase.dart';

class ConversationDetailCubit extends Cubit<ConversationDetailState> {
  final GetConversationUsecase _getConversationUsecase;

  ConversationDetailCubit({
    required GetConversationUsecase getConversationUsecase,
  }) : _getConversationUsecase = getConversationUsecase,
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
}
