import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String clientMessageId;
  final String id;
  final String conversationId;
  final String? text;
  final String senderId;
  final String type;
  final String status;
  final bool isDeleted;
  final String? replyTo;
  final Map<String, dynamic> reactions;
  final String? mediaUrl;
  final String? mediaType;
  final Timestamp createdAt;

  const MessageModel({
    required this.clientMessageId,
    required this.id,
    required this.conversationId,
    this.text,
    required this.senderId,
    required this.type,
    required this.status,
    this.isDeleted = false,
    this.replyTo,
    required this.reactions,
    this.mediaUrl,
    this.mediaType,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    clientMessageId,
    id,
    conversationId,
    text,
    senderId,
    type,
    status,
    isDeleted,
    replyTo,
    reactions,
    mediaUrl,
    mediaType,
    createdAt,
  ];

  Map<String, dynamic> toJson() {
    return {
      'clientMessageId': clientMessageId,
      'id': id,
      'conversationId': conversationId,
      'text': text,
      'senderId': senderId,
      'type': type,
      'status': status,
      'isDeleted': isDeleted,
      'replyTo': replyTo,
      'reactions': reactions,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'createdAt': createdAt,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      clientMessageId:
          json['clientMessageId']?.toString() ?? json['id']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      text: json['text'],
      senderId: json['senderId']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',
      status: json['status']?.toString() ?? 'sent',
      isDeleted: json['isDeleted'] ?? false,
      replyTo: json['replyTo'],
      reactions: json['reactions'] is Map
          ? Map<String, dynamic>.from(json['reactions'] as Map)
          : <String, dynamic>{},
      mediaUrl: json['mediaUrl'],
      mediaType: json['mediaType'],
      createdAt: json['createdAt'] is Timestamp
          ? json['createdAt']
          : Timestamp.fromMillisecondsSinceEpoch(
              (json['createdAt'] as int?) ??
                  DateTime.now().millisecondsSinceEpoch,
            ),
    );
  }
}
