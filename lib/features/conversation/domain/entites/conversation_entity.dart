import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_last_message_entity.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_type.dart';
import 'package:social_app/features/conversation/domain/entites/unread_count.dart';

class ConversationEntity extends Equatable {
  final String id;
  final ConversationType type;
  final List<String> participantIds;
  final ConversationLastMessageEntity? lastMessage;
  final Map<String, UnreadCount> unreadCountMap;
  final Timestamp createdAt;
  final String name;
  final String? avatarUrl;

  const ConversationEntity({
    required this.id,
    required this.type,
    required this.participantIds,
    required this.unreadCountMap,
    required this.createdAt,
    required this.name,
    this.avatarUrl,
    this.lastMessage,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    participantIds,
    lastMessage,
    unreadCountMap,
    createdAt,
    name,
    avatarUrl,
  ];

  ConversationEntity copyWith({
    String? id,
    ConversationType? type,
    List<String>? participantIds,
    ConversationLastMessageEntity? lastMessage,
    Map<String, UnreadCount>? unreadCountMap,
    Timestamp? createdAt,
    String? name,
    String? avatarUrl,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      participantIds: participantIds ?? this.participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCountMap: unreadCountMap ?? this.unreadCountMap,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
