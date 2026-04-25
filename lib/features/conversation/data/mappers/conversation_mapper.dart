import 'package:social_app/features/conversation/data/mappers/conversation_last_message_mapper.dart';
import 'package:social_app/features/conversation/data/models/conversation_model.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_type.dart';

class ConversationMapper {
  const ConversationMapper._();

  static ConversationEntity toEntity(ConversationModel model) {
    return ConversationEntity(
      id: model.id,
      lastMessage: model.lastMessage != null
          ? ConversationLastMessageMapper.toEntity(model.lastMessage!)
          : null,
      participantIds: List<String>.from(model.participantIds),
      unreadCountMap: model.unreadCountMap,
      createdAt: model.createdAt,
      type: ConversationType.values.firstWhere(
        (e) => e.name == model.type,
        orElse: () =>
            ConversationType.direct, // fallback or handle error as needed
      ),
      avatarUrl: model.avatarUrl,
      name: model.name,
    );
  }

  static ConversationModel toModel(ConversationEntity entity) {
    return ConversationModel(
      id: entity.id,
      lastMessage: entity.lastMessage != null
          ? ConversationLastMessageMapper.toModel(entity.lastMessage!)
          : null,
      participantIds: List<String>.from(entity.participantIds),
      unreadCountMap: entity.unreadCountMap,
      createdAt: entity.createdAt,
      type: entity.type.name,
      name: entity.name,
      avatarUrl: entity.avatarUrl,
    );
  }
}
