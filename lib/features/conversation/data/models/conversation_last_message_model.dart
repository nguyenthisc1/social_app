import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ConversationLastMessageModel extends Equatable {
  final String id;
  final String senderId;
  final String type;
  final String? text;
  final String? mediaUrl;
  final String? mediaType;
  final bool isDeleted;
  final Timestamp createdAt;

  const ConversationLastMessageModel({
    required this.id,
    required this.senderId,
    required this.type,
    this.text,
    this.mediaUrl,
    required this.createdAt,
    this.mediaType,
    this.isDeleted = false,
  });

  @override
  List<Object?> get props => [
    id,
    senderId,
    type,
    text,
    mediaUrl,
    mediaType,
    isDeleted,
    createdAt,
  ];

  factory ConversationLastMessageModel.fromJson(Map<String, dynamic> json) {
    return ConversationLastMessageModel(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      type: json['type']?.toString() ?? 'text',
      text: json['text'],
      mediaUrl: json['mediaUrl'],
      mediaType: json['mediaType'],
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] is Timestamp
          ? json['createdAt']
          : Timestamp.fromMillisecondsSinceEpoch(
              (json['createdAt'] as int?) ??
                  DateTime.now().millisecondsSinceEpoch,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'type': type,
      'text': text,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
    };
  }
}
