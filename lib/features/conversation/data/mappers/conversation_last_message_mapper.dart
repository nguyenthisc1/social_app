import 'package:social_app/features/conversation/data/models/conversation_last_message_model.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_last_message_entity.dart';
import 'package:social_app/features/message/domain/entites/message_type.dart';

class ConversationLastMessageMapper {
  const ConversationLastMessageMapper._();

  static ConversationLastMessageEntity toEntity(
    ConversationLastMessageModel model,
  ) {
    return ConversationLastMessageEntity(
      id: model.id,
      senderId: model.senderId,
      text: model.text,
      mediaUrl: model.mediaUrl,
      mediaType: model.mediaType,
      type: MessageType.values.firstWhere(
        (e) => e.name == model.type,
        orElse: () => MessageType.text,
      ),
      createdAt: model.createdAt,
      isDeleted: model.isDeleted,
    );
  }

  static ConversationLastMessageModel toModel(
    ConversationLastMessageEntity entity,
  ) {
    return ConversationLastMessageModel(
      id: entity.id,
      senderId: entity.senderId,
      text: entity.text,
      mediaUrl: entity.mediaUrl,
      mediaType: entity.mediaType,
      type: entity.type.name,
      isDeleted: entity.isDeleted,
      createdAt: entity.createdAt,
    );
  }
}
