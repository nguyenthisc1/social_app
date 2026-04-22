import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/repositories/message_repository.dart';

class GetMessagesByConversationUsecase {
  final MessageRepository _messageRepository;

  const GetMessagesByConversationUsecase(this._messageRepository);

  Future<List<MessageEntity>> call(String conversationId) {
    return _messageRepository.getMessagesByConversation(conversationId);
  }
}
