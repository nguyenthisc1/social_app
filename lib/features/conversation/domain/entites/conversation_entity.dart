import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String id;
  final List<String> memberIds;
  final String? lastMessage;
  final Timestamp? lastMessageAt;
  final String? lastMessageType;
  final String? lastSenderId;
  final Map<String, int> unreadCountMap;
  final Timestamp createdAt;

  const ConversationEntity({
    required this.id,
    this.lastMessage,
    this.lastMessageAt,
    this.lastMessageType,
    this.lastSenderId,
    required this.memberIds,
    required this.unreadCountMap,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    lastMessage,
    lastMessageAt,
    lastMessageType,
    lastSenderId,
    memberIds,
    unreadCountMap,
    createdAt,
  ];

  ConversationEntity copyWith({
    String? id,
    List<String>? memberIds,
    String? lastMessage,
    Timestamp? lastMessageAt,
    String? lastMessageType,
    String? lastSenderId,
    Map<String, int>? unreadCountMap,
    Timestamp? createdAt,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      memberIds: memberIds ?? this.memberIds,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      unreadCountMap: unreadCountMap ?? this.unreadCountMap,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
