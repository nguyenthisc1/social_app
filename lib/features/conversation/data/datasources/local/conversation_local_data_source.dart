import 'package:social_app/features/conversation/data/models/conversation_model.dart';

abstract interface class ConversationLocalDataSource {
  Future<void> cacheConversations(
    String userId,
    List<ConversationModel> conversations,
  );
  Future<List<ConversationModel>> getCachedConversations(String userId);
  Future<void> clearConversations(String userId);
}
