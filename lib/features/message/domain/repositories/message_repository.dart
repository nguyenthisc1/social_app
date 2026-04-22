import 'package:social_app/features/message/domain/entites/message_entity.dart';

abstract interface class MessageRepository {
  Future<MessageEntity> sendMessage({
    required String conversationId,
    required String text,
    required String currentUserId,
  });
  Future<List<MessageEntity>> getMessagesByConversation(String conversationId);
}
