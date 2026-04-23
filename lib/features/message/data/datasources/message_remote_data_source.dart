import 'package:social_app/features/message/data/models/message_model.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';

abstract interface class MessageRemoteDataSource {
  Future<MessageModel> sendMessage({
    required String conversationId,
    required MessageEntity message,
    required String currentUserId,
  });
  Future<List<MessageModel>> getMessagesByConversation(String conversationId);
  Stream<List<MessageModel>> watchMessagesByConversation(String conversationId);
}
