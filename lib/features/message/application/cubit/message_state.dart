import 'package:social_app/features/message/domain/entites/message_entity.dart';

class MessageState {
  final bool isLoading;
  final String? errorMessage;
  final List<MessageEntity> messages;

  const MessageState({
    required this.isLoading,
    this.errorMessage,
    required this.messages,
  });

  factory MessageState.initial() {
    return MessageState(isLoading: false, errorMessage: '', messages: const []);
  }

  MessageState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,

    List<MessageEntity>? messages,
  }) {
    return MessageState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      messages: messages ?? this.messages,
    );
  }
}
