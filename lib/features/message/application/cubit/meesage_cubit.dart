import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/message/application/cubit/message_state.dart';
import 'package:social_app/features/message/data/datasources/local/message_local_data_source.dart';
import 'package:social_app/features/message/data/mappers/message_mapper.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/entites/message_delivery_status.dart';
import 'package:social_app/features/message/domain/message_params.dart';
import 'package:social_app/features/message/domain/usecases/get_messages_by_conversation_usecase.dart';
import 'package:social_app/features/message/domain/usecases/send_message_usecase.dart';
import 'package:social_app/features/message/domain/usecases/watch_messages_by_conversation_usecase.dart';

class MessageCubit extends Cubit<MessageState> {
  final GetMessagesByConversationUsecase _getMessagesByConversationUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  final WatchMessagesByConversationUseCase _watchMessagesByConversationUseCase;
  final MessageLocalDataSource _localDataSource;

  StreamSubscription<List<MessageEntity>>? _subscription;

  MessageCubit({
    required GetMessagesByConversationUsecase getMessagesByConversationUsecase,
    required SendMessageUsecase sendMessageUsecase,
    required WatchMessagesByConversationUseCase
    watchMessagesByConversationUseCase,
    required MessageLocalDataSource localDataSource,
  }) : _sendMessageUsecase = sendMessageUsecase,
       _watchMessagesByConversationUseCase = watchMessagesByConversationUseCase,
       _localDataSource = localDataSource,
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
    final optimisticMessages = [
      message,
      ...state.messages.where(
        (m) => m.id != message.id && m.clientMessageId != message.clientMessageId,
      ),
    ];

    emit(
      state.copyWith(
        isLoading: false,
        clearError: true,
        messages: optimisticMessages,
      ),
    );

    await _localDataSource.upsertMessage(
      conversationId,
      MessageMapper.toModel(message),
    );

    try {
      await _sendMessageUsecase(
        SendMessageParams(
          conversationId: conversationId,
          message: message,
          currentUserId: currentUserId,
        ),
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
      final failedMessage = message.copyWith(
        status: MessageDeliveryStatus.failed,
      );

      emit(
        state.copyWith(
          isLoading: false,
          clearError: false,
          errorMessage: error.toString(),
          messages: [
            failedMessage,
            ...state.messages.where(
              (m) =>
                  m.id != failedMessage.id &&
                  m.clientMessageId != failedMessage.clientMessageId,
            ),
          ],
        ),
      );

      await _localDataSource.upsertMessage(
        conversationId,
        MessageMapper.toModel(failedMessage),
      );

      return;
    }
  }

  Future<void> sendMessageLocal({
    required String conversationId,
    required MessageEntity message,
    required String currentUserId,
  }) async {
    try {
      emit(
        state.copyWith(
          isLoading: false,
          clearError: true,
          messages: [
            message,
            ...state.messages.where(
              (m) =>
                  m.id != message.id &&
                  m.clientMessageId != message.clientMessageId,
            ),
          ],
        ),
      );

      await _localDataSource.upsertMessage(
        conversationId,
        MessageMapper.toModel(message),
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

  Future<void> markMessageFailed({
    required String conversationId,
    required String clientMessageId,
  }) async {
    final target = state.messages
        .where((message) => message.clientMessageId == clientMessageId)
        .cast<MessageEntity?>()
        .firstWhere((message) => message != null, orElse: () => null);

    if (target == null) return;

    final failedMessage = target.copyWith(
      status: MessageDeliveryStatus.failed,
    );

    emit(
      state.copyWith(
        isLoading: false,
        clearError: true,
        messages: [
          failedMessage,
          ...state.messages.where(
            (message) => message.clientMessageId != clientMessageId,
          ),
        ],
      ),
    );

    await _localDataSource.upsertMessage(
      conversationId,
      MessageMapper.toModel(failedMessage),
    );
  }

  Future<void> watchMessages(String conversationId) async {
    await _subscription?.cancel();

    emit(state.copyWith(isLoading: false, clearError: true));

    _subscription = _watchMessagesByConversationUseCase(conversationId).listen(
      (messages) {
        // retain any "pending" (clientMessageId) messages not yet on server that are missing from Firestore result
        final pendingMessages = state.messages.where(
          (m) =>
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
