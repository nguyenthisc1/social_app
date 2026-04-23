import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';

class ConversationDetailState {
  final bool isLoading;
  final String? errorMessage;
  final ConversationEntity? conversation;
  final String currentUserId;
  final String draft;

  const ConversationDetailState({
    required this.isLoading,
    this.errorMessage,
    required this.conversation,
    required this.currentUserId,
    required this.draft,
  });

  factory ConversationDetailState.initial() {
    return ConversationDetailState(
      isLoading: false,
      conversation: null,
      currentUserId: '',
      draft: '',
    );
  }

  ConversationDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    ConversationEntity? conversation,
    String? currentUserId,
    String? draft,
  }) {
    return ConversationDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      conversation: conversation ?? this.conversation,
      currentUserId: currentUserId ?? this.currentUserId,
      draft: draft ?? this.draft,
    );
  }
}
