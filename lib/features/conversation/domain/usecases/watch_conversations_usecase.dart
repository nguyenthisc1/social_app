import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/repositories/conversation_repository.dart';

class WatchConversationsUsecase {
  final ConversationRepository _conversationRepository;

  const WatchConversationsUsecase(this._conversationRepository);

  Stream<List<ConversationEntity>> call(String currentUserId) {
    final conversations = _conversationRepository.watchConversations(
      currentUserId,
    );

    return conversations;
  }
}
