import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String clientMessageId;
  final String id;
  final String conversationId;
  final String? text;
  final String? fileName;
  final String? fileUrl;
  final String senderId;
  final String type;
  final String status;
  final Timestamp createdAt;

  const MessageModel({
    required this.clientMessageId,
    required this.id,
    required this.conversationId,
    this.text,
    this.fileName,
    this.fileUrl,
    required this.senderId,
    required this.type,
    required this.createdAt,
    required this.status,
  });

  @override
  List<Object?> get props => [
    clientMessageId,
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

  Map<String, dynamic> toJson() {
    return {
      'clientMessageId': clientMessageId,
      'id': id,
      'conversationId': conversationId,
      'text': text,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'senderId': senderId,
      'type': type,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final createdAt =
        json['createdAt'] ?? json['clientCreatedAt'] ?? Timestamp.now();

    return MessageModel(
      clientMessageId: json['clientMessageId'] ?? json['id'],
      id: json['id'],
      conversationId: json['conversationId'],
      text: json['text'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
      senderId: json['senderId'],
      type: json['type'],
      createdAt: createdAt,
      status: json['status'] ?? 'sent',
    );
  }
}
