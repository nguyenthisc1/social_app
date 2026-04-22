import 'package:social_app/features/conversation/data/models/conversation_model.dart';

abstract interface class ConversationRemoteDataSource {
  Future<ConversationModel> createConversation(List<String> memberIds);
  Future<ConversationModel?> getConversation(String id);
  Future<List<ConversationModel>> getConversations(String currentUserId);
  Future<ConversationModel> updateConversation();
}
