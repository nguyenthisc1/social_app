import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/repositories/message_repository.dart';

class WatchMessagesByConversationUseCase {
  final MessageRepository _messageRepository;

  const WatchMessagesByConversationUseCase(this._messageRepository);

  Stream<List<MessageEntity>> call(String conversationId) {
    return _messageRepository.watchMessagesByConversation(conversationId);
  }
}
