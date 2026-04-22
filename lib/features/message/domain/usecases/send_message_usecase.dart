import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/repositories/message_repository.dart';

class SendMessageUsecase {
  final MessageRepository _messageRepository;

  const SendMessageUsecase(this._messageRepository);

  Future<MessageEntity> call({
    required String conversationId,
    required String text,
    required String currentUserId,
  }) {
    return _messageRepository.sendMessage(
      conversationId: conversationId,
      text: text,
      currentUserId: currentUserId,
    );
  }
}
