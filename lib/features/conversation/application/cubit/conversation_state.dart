import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';

class ConversationState {
  final bool isLoading;
  final String? errorMessage;
  final List<ConversationEntity> conversations;
  final String currentUserId;

  const ConversationState({
    required this.isLoading,
    required this.errorMessage,
    required this.conversations,
    required this.currentUserId,
  });

  factory ConversationState.initial() {
    return ConversationState(
      isLoading: false,
      errorMessage: null,
      conversations: [],
      currentUserId: '',
    );
  }

  ConversationState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<ConversationEntity>? conversations,
    String? currentUserId,
  }) {
    return ConversationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      conversations: conversations ?? this.conversations,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}
