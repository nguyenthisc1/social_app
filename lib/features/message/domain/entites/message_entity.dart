import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/features/message/domain/entites/message_delivery_status.dart';

enum MessageType { text, image }

class MessageEntity extends Equatable {
  final String clientMessageId;
  final String id;
  final String conversationId;
  final String? text;
  final String? fileName;
  final String? fileUrl;
  final String senderId;
  final String type;
  final MessageDeliveryStatus status;
  final Timestamp createdAt;

  const MessageEntity({
    required this.clientMessageId,
    required this.id,
    required this.conversationId,
    this.fileName,
    this.fileUrl,
    this.text,
    required this.senderId,
    required this.type,
    required this.createdAt,
    required this.status,
  });

  MessageEntity copyWith({
    String? clientMessageId,
    String? id,
    String? conversationId,
    String? text,
    String? fileName,
    String? fileUrl,
    String? senderId,
    String? type,
    MessageDeliveryStatus? status,
    Timestamp? createdAt,
  }) {
    return MessageEntity(
      clientMessageId: clientMessageId ?? this.clientMessageId,
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    conversationId,
    text,
    fileName,
    fileUrl,
    senderId,
    type,
    status,
    createdAt,
  ];
}
