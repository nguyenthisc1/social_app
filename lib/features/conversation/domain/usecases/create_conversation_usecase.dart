import 'package:social_app/features/conversation/domain/conversation_exeptions.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/repositories/conversation_repository.dart';

class CreateConversationUsecase {
  final ConversationRepository _conversationRepository;

  const CreateConversationUsecase(this._conversationRepository);

  Future<ConversationEntity> call(List<String> participantIds) {
    if (participantIds.isEmpty) {
      throw ConversationExeptions(
        message: 'Conversation must have at least one member.',
      );
    }

    return _conversationRepository.createConversation(participantIds);
  }
}
