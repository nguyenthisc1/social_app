import 'package:social_app/features/message/data/models/message_model.dart';
import 'package:social_app/features/message/domain/entites/message_delivery_status.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/entites/message_type.dart';

class MessageMapper {
  const MessageMapper._();

  static MessageEntity toEntity(MessageModel model) {
    return MessageEntity(
      clientMessageId: model.clientMessageId,
      id: model.id,
      conversationId: model.conversationId,
      createdAt: model.createdAt,
      senderId: model.senderId,
      type: MessageType.values.firstWhere(
        (e) => e.name == model.type,
        orElse: () => MessageType.text,
      ),
      text: model.text,
      status: MessageDeliveryStatus.values.firstWhere(
        (e) => e.name == model.status,
        orElse: () => MessageDeliveryStatus.sent,
      ),
      isDeleted: model.isDeleted,
      reactions: model.reactions,
      replyTo: model.replyTo,
      mediaType: model.mediaType,
      mediaUrl: model.mediaUrl,
    );
  }

  static MessageModel toModel(MessageEntity entity) {
    return MessageModel(
      clientMessageId: entity.clientMessageId,
      id: entity.id,
      conversationId: entity.conversationId,
      text: entity.text,
      mediaUrl: entity.mediaUrl,
      mediaType: entity.mediaType,
      senderId: entity.senderId,
      type: entity.type.name,
      createdAt: entity.createdAt,
      status: entity.status.name,
      replyTo: entity.replyTo,
      isDeleted: entity.isDeleted,
      reactions: entity.reactions,
    );
  }
}
