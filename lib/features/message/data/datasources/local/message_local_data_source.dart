import '../../models/message_model.dart';

abstract interface class MessageLocalDataSource {
  Future<void> cacheMessages(
    String conversationId,
    List<MessageModel> messages,
  );
  Future<List<MessageModel>> getCachedMessages(String conversationId);
  Future<void> upsertMessage(String conversationId, MessageModel message);
  Future<void> clearMessages(String conversationId);
}
