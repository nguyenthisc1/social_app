import 'package:social_app/features/message/data/models/message_model.dart';
import 'package:social_app/features/message/domain/entites/message_delivery_status.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';

class MessageMapper {
  const MessageMapper._();

  static MessageEntity toEntity(MessageModel model) {
    return MessageEntity(
      clientMessageId: model.clientMessageId,
      id: model.id,
      conversationId: model.conversationId,
      createdAt: model.createdAt,
      fileName: model.fileName,
      fileUrl: model.fileUrl,
      senderId: model.senderId,
      type: model.type,
      text: model.text,
      status: MessageDeliveryStatus.values.firstWhere(
        (e) => e.name == model.status,
        orElse: () => MessageDeliveryStatus.sent,
      ),
    );
  }

  static MessageModel toModel(MessageEntity entity) {
    return MessageModel(
      clientMessageId: entity.clientMessageId,
      id: entity.id,
      conversationId: entity.conversationId,
      text: entity.text,
      fileName: entity.fileName,
      fileUrl: entity.fileUrl,
      senderId: entity.senderId,
      type: entity.type,
      createdAt: entity.createdAt,
      status: entity.status.name,
    );
  }
}
