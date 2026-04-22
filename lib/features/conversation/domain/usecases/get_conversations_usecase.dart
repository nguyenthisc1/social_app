import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/repositories/conversation_repository.dart';

class GetConversationsUsecase {
  final ConversationRepository _conversationRepository;

  const GetConversationsUsecase(this._conversationRepository);

  Future<List<ConversationEntity>> call(String currentUserId) {
    return _conversationRepository.getConversations(currentUserId);
  }
}
