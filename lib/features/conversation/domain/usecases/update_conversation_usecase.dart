import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/repositories/conversation_repository.dart';

class UpdateConversationsUsecase {
  final ConversationRepository _conversationRepository;

  const UpdateConversationsUsecase(this._conversationRepository);

  Future<ConversationEntity> call(ConversationEntity conversaion) {
    return _conversationRepository.updateConversation(conversaion);
  }
}
