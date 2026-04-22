import 'package:social_app/features/message/data/models/message_model.dart';

abstract interface class MessageRemoteDataSource {
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String text,
    required String currentUserId,
  });
  Future<List<MessageModel>> getMessagesByConversation(String conversationId);
}
