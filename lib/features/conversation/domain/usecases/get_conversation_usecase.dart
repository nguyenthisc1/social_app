import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/repositories/conversation_repository.dart';

class GetConversationUsecase {
  final ConversationRepository _conversationRepository;

  const GetConversationUsecase(this._conversationRepository);

  Future<ConversationEntity?> call(String id) {
    return _conversationRepository.getConversation(id);
  }
}
