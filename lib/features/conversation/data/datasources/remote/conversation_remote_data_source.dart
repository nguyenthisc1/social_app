import 'package:social_app/features/conversation/data/models/conversation_model.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';

abstract interface class ConversationRemoteDataSource {
  Future<ConversationModel> createConversation(List<String> participantIds);
  Future<ConversationModel?> getConversation(String id);
  Future<List<ConversationModel>> getConversations(String currentUserId);
  Future<ConversationModel> updateConversation(ConversationEntity conversation);

  Stream<List<ConversationModel>> watchConversations(String currentUserId);
}
