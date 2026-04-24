import 'package:social_app/features/conversation/data/datasources/local/conversation_local_data_source.dart';
import 'package:social_app/features/conversation/data/models/conversation_model.dart';

class ConversationHiveLocalDataSource implements ConversationLocalDataSource {
  @override
  Future<void> cacheConversations(
    String userId,
    List<ConversationModel> conversations,
  ) {
    // TODO: implement cacheConversations
    throw UnimplementedError();
  }

  @override
  Future<void> clearConversations(String userId) {
    // TODO: implement clearConversations
    throw UnimplementedError();
  }

  @override
  Future<List<ConversationModel>> getCachedConversations(String userId) {
    // TODO: implement getCachedConversations
    throw UnimplementedError();
  }
}
