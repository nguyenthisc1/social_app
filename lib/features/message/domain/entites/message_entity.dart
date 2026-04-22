import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum MessageType { text, image }

class MessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String? text;
  final String? fileName;
  final String? fileUrl;
  final String senderId;
  final String type;
  final Timestamp createdAt;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    this.fileName,
    this.fileUrl,
    this.text,
    required this.senderId,
    required this.type,
    required this.createdAt,
  });

  MessageEntity copyWith({
    String? id,
    String? conversationId,
    String? text,
    String? fileName,
    String? fileUrl,
    String? senderId,
    String? type,
    Timestamp? createdAt,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
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
    createdAt,
  ];
}
