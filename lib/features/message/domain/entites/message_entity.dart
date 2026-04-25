import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/features/message/domain/entites/message_delivery_status.dart';
import 'package:social_app/features/message/domain/entites/message_type.dart';

class MessageEntity extends Equatable {
  final String clientMessageId;
  final String id;
  final String conversationId;
  final String? text;
  final String senderId;
  final MessageType type;
  final MessageDeliveryStatus status;
  final bool isDeleted;
  final String? replyTo;
  final Map<String, dynamic> reactions;
  final String? mediaUrl;
  final String? mediaType;
  final Timestamp createdAt;

  const MessageEntity({
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

  MessageEntity copyWith({
    String? clientMessageId,
    String? id,
    String? conversationId,
    String? text,
    String? senderId,
    MessageType? type,
    MessageDeliveryStatus? status,
    bool? isDeleted,
    String? replyTo,
    Map<String, dynamic>? reactions,
    String? mediaUrl,
    String? mediaType,
    Timestamp? createdAt,
  }) {
    return MessageEntity(
      clientMessageId: clientMessageId ?? this.clientMessageId,
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      replyTo: replyTo ?? this.replyTo,
      reactions: reactions ?? this.reactions,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
}
