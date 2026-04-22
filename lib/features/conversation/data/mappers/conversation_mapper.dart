import 'package:social_app/features/conversation/data/models/conversation_model.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';

class ConversationMapper {
  const ConversationMapper._();

  static ConversationEntity toEntity(ConversationModel model) {
    return ConversationEntity(
      id: model.id,
      lastMessage: model.lastMessage,
      lastMessageAt: model.lastMessageAt,
      lastMessageType: model.lastMessageType,
      lastSenderId: model.lastSenderId,
      memberIds: List<String>.from(model.memberIds),
      unreadCountMap: model.unreadCountMap,
      createdAt: model.createdAt,
    );
  }

  static ConversationModel toModel(ConversationEntity entity) {
    return ConversationModel(
      id: entity.id,
      lastMessage: entity.lastMessage,
      lastMessageAt: entity.lastMessageAt,
      lastMessageType: entity.lastMessageType,
      lastSenderId: entity.lastSenderId,
      memberIds: List<String>.from(entity.memberIds),
      unreadCountMap: entity.unreadCountMap,
      createdAt: entity.createdAt,
    );
  }
}
