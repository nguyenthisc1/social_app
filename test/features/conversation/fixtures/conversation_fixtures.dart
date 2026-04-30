import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/conversation/data/models/conversation_last_message_model.dart';
import 'package:social_app/features/conversation/data/models/conversation_model.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_last_message_entity.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_type.dart';
import 'package:social_app/features/conversation/domain/entites/unread_count.dart';
import 'package:social_app/features/message/domain/entites/message_delivery_status.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/entites/message_type.dart';

final fakeConversationCreatedAt = Timestamp.fromMillisecondsSinceEpoch(
  1710000000000,
);
final fakeOlderConversationCreatedAt = Timestamp.fromMillisecondsSinceEpoch(
  1700000000000,
);
final fakeLastMessageCreatedAt = Timestamp.fromMillisecondsSinceEpoch(
  1710000001000,
);
final fakeNewerMessageCreatedAt = Timestamp.fromMillisecondsSinceEpoch(
  1710000002000,
);

const fakeCurrentUserId = 'user_1';
const fakeOtherUserId = 'user_2';
const fakeThirdUserId = 'user_3';

final fakeLastMessageEntity = ConversationLastMessageEntity(
  id: 'message_1',
  senderId: fakeOtherUserId,
  type: MessageType.text,
  text: 'Hello',
  createdAt: fakeLastMessageCreatedAt,
);

final fakeLastMessageModel = ConversationLastMessageModel(
  id: 'message_1',
  senderId: fakeOtherUserId,
  type: 'text',
  text: 'Hello',
  createdAt: fakeLastMessageCreatedAt,
);

final fakeConversationEntity = ConversationEntity(
  id: 'conversation_1',
  type: ConversationType.direct,
  participantIds: const [fakeCurrentUserId, fakeOtherUserId],
  unreadCountMap: const {
    fakeCurrentUserId: UnreadCount(count: 1),
    fakeOtherUserId: UnreadCount(count: 0),
  },
  createdAt: fakeConversationCreatedAt,
  name: 'Chat with user_2',
  avatarUrl: null,
  lastMessage: fakeLastMessageEntity,
);

final fakeConversationModel = ConversationModel(
  id: 'conversation_1',
  type: 'direct',
  participantIds: const [fakeCurrentUserId, fakeOtherUserId],
  unreadCountMap: const {
    fakeCurrentUserId: UnreadCount(count: 1),
    fakeOtherUserId: UnreadCount(count: 0),
  },
  createdAt: fakeConversationCreatedAt,
  name: 'Chat with user_2',
  avatarUrl: null,
  lastMessage: fakeLastMessageModel,
);

final fakeOlderConversationEntity = ConversationEntity(
  id: 'conversation_2',
  type: ConversationType.direct,
  participantIds: const [fakeCurrentUserId, fakeThirdUserId],
  unreadCountMap: const {
    fakeCurrentUserId: UnreadCount(count: 0),
    fakeThirdUserId: UnreadCount(count: 0),
  },
  createdAt: fakeOlderConversationCreatedAt,
  name: 'Chat with user_3',
  avatarUrl: null,
  lastMessage: ConversationLastMessageEntity(
    id: 'message_old',
    senderId: fakeThirdUserId,
    type: MessageType.text,
    text: 'Old message',
    createdAt: fakeOlderConversationCreatedAt,
  ),
);

final fakeOlderConversationModel = ConversationModel(
  id: 'conversation_2',
  type: 'direct',
  participantIds: const [fakeCurrentUserId, fakeThirdUserId],
  unreadCountMap: const {
    fakeCurrentUserId: UnreadCount(count: 0),
    fakeThirdUserId: UnreadCount(count: 0),
  },
  createdAt: fakeOlderConversationCreatedAt,
  name: 'Chat with user_3',
  avatarUrl: null,
  lastMessage: ConversationLastMessageModel(
    id: 'message_old',
    senderId: fakeThirdUserId,
    type: 'text',
    text: 'Old message',
    createdAt: fakeOlderConversationCreatedAt,
  ),
);

final fakeUpdatedConversationEntity = fakeConversationEntity.copyWith(
  unreadCountMap: const {
    fakeCurrentUserId: UnreadCount(count: 0),
    fakeOtherUserId: UnreadCount(count: 2),
  },
);

final fakeMessageEntity = MessageEntity(
  clientMessageId: 'client_message_1',
  id: 'message_new',
  conversationId: 'conversation_2',
  text: 'Newest message',
  senderId: fakeCurrentUserId,
  type: MessageType.text,
  status: MessageDeliveryStatus.sent,
  reactions: const {},
  createdAt: fakeNewerMessageCreatedAt,
);

StreamController<List<ConversationEntity>> buildConversationEntityController() {
  return StreamController<List<ConversationEntity>>();
}

StreamController<List<ConversationModel>> buildConversationModelController() {
  return StreamController<List<ConversationModel>>();
}
