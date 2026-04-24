import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/message/application/cubit/message_state.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/usecases/get_messages_by_conversation_usecase.dart';
import 'package:social_app/features/message/domain/usecases/send_message_usecase.dart';
import 'package:social_app/features/message/domain/usecases/watch_messages_by_conversation_usecase.dart';

class MessageCubit extends Cubit<MessageState> {
  final GetMessagesByConversationUsecase _getMessagesByConversationUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  final WatchMessagesByConversationUseCase _watchMessagesByConversationUseCase;

  StreamSubscription<List<MessageEntity>>? _subscription;

  MessageCubit({
    required GetMessagesByConversationUsecase getMessagesByConversationUsecase,
    required SendMessageUsecase sendMessageUsecase,
    required WatchMessagesByConversationUseCase
    watchMessagesByConversationUseCase,
  }) : _sendMessageUsecase = sendMessageUsecase,
       _watchMessagesByConversationUseCase = watchMessagesByConversationUseCase,
       _getMessagesByConversationUsecase = getMessagesByConversationUsecase,
       super(MessageState.initial());

  Future<void> getMessages(String conversationId) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final messages = await _getMessagesByConversationUsecase(conversationId);
      emit(
        state.copyWith(isLoading: false, clearError: true, messages: messages),
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

  Future<void> sendMessage({
    required String conversationId,
    required MessageEntity message,
    required String currentUserId,
  }) async {
    emit(
      state.copyWith(
        isLoading: false,
        clearError: true,
        messages: [message, ...state.messages],
      ),
    );

    try {
      await _sendMessageUsecase(
        conversationId: conversationId,
        message: message,
        currentUserId: currentUserId,
      );

      // final newMessages = [
      //   newMessage,
      //   ...state.messages.where((m) => m.id != message.id),
      // ];

      // emit(
      //   state.copyWith(
      //     isLoading: false,
      //     clearError: true,
      //     messages: newMessages,
      //   ),
      // );
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

  Future<void> watchMessages(String conversationId) async {
    await _subscription?.cancel();

    emit(state.copyWith(isLoading: false, clearError: true));

    _subscription = _watchMessagesByConversationUseCase(conversationId).listen(
      (messages) {
        // retain any "pending" (clientMessageId) messages not yet on server that are missing from Firestore result
        final pendingMessages = state.messages.where(
          (m) =>
              m.clientMessageId != null &&
              !messages.any((msg) => msg.clientMessageId == m.clientMessageId),
        );

        emit(
          state.copyWith(
            isLoading: false,
            clearError: true,
            messages: [...pendingMessages, ...messages],
          ),
        );
      },
      onError: (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
      },
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }

  void clear() {
    emit(MessageState.initial());
  }
}
