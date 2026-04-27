import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';

abstract interface class ConversationRepository {
  Future<ConversationEntity> createConversation(List<String> participantIds);
  Future<ConversationEntity?> getConversation(String id);
  Future<List<ConversationEntity>> getConversations(String currentUserId);
  Future<ConversationEntity> updateConversation(
    ConversationEntity conversation,
  );

  Stream<List<ConversationEntity>> watchConversations(String currentUserId);
}
