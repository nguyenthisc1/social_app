import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/features/conversation/data/models/conversation_last_message_model.dart';
import 'package:social_app/features/conversation/domain/entites/unread_count.dart';

class ConversationModel extends Equatable {
  final String id;
  final String type;
  final List<String> participantIds;
  final ConversationLastMessageModel? lastMessage;
  final Map<String, UnreadCount> unreadCountMap;
  final Timestamp createdAt;
  final String name;
  final String? avatarUrl;

  const ConversationModel({
    required this.id,
    required this.type,
    required this.participantIds,
    this.lastMessage,
    required this.unreadCountMap,
    required this.createdAt,
    required this.name,
    this.avatarUrl,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'participantIds': participantIds,
      'lastMessage': lastMessage?.toJson(),
      'unreadCountMap': unreadCountMap.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'createdAt': createdAt,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final unreadCountMapRaw = json['unreadCountMap'];

    return ConversationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      participantIds: List<String>.from(json['participantIds'] ?? const []),
      lastMessage: json['lastMessage'] == null
          ? null
          : json['lastMessage'] is ConversationLastMessageModel
          ? json['lastMessage']
          : ConversationLastMessageModel.fromJson(
              Map<String, dynamic>.from(json['lastMessage'] as Map),
            ),

      unreadCountMap: unreadCountMapRaw is Map
          ? unreadCountMapRaw.map(
              (key, value) => MapEntry(key.toString(), switch (value) {
                UnreadCount unreadCount => unreadCount,
                Map<String, dynamic> unreadCountJson => UnreadCount.fromJson(
                  unreadCountJson,
                ),
                Map unreadCountJson => UnreadCount.fromJson(
                  Map<String, dynamic>.from(unreadCountJson),
                ),
                _ => const UnreadCount(count: 0),
              }),
            )
          : <String, UnreadCount>{},
      createdAt: json['createdAt'] is Timestamp
          ? json['createdAt']
          : Timestamp.fromMillisecondsSinceEpoch(
              (json['createdAt'] as int?) ??
                  DateTime.now().millisecondsSinceEpoch,
            ),
      name: json['name']?.toString() ?? '',
      avatarUrl: json['avatarUrl'],
    );
  }
}
