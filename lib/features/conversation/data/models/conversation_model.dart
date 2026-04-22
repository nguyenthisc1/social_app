import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ConversationModel extends Equatable {
  final String id;
  final List<String> memberIds;
  final String? lastMessage;
  final Timestamp? lastMessageAt;
  final String? lastMessageType;
  final String? lastSenderId;
  final Map<String, int> unreadCountMap;
  final Timestamp createdAt;

  const ConversationModel({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt,
      'lastMessageType': lastMessageType,
      'lastSenderId': lastSenderId,
      'memberIds': memberIds,
      'unreadCountMap': unreadCountMap.map(
        (key, value) => MapEntry(key, value),
      ),
      'createdAt': createdAt,
    };
  }

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'],
      lastMessageType: json['lastMessageType'],
      lastSenderId: json['lastSenderId'],
      memberIds: List<String>.from(json['memberIds']),
      unreadCountMap: (json['unreadCountMap'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as int),
      ),
      createdAt: json['createdAt'],
    );
  }
}
