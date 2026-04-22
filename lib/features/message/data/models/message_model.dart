import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String id;
  final String conversationId;
  final String? text;
  final String? fileName;
  final String? fileUrl;
  final String senderId;
  final String type;
  final Timestamp createdAt;

  const MessageModel({
    required this.id,
    required this.conversationId,
    this.text,
    this.fileName,
    this.fileUrl,
    required this.senderId,
    required this.type,
    required this.createdAt,
  });

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'text': text,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'senderId': senderId,
      'type': type,
      'createdAt': createdAt,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      conversationId: json['conversationId'],
      text: json['text'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
      senderId: json['senderId'],
      type: json['type'],
      createdAt: json['createdAt'],
    );
  }

  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? text,
    String? fileName,
    String? fileUrl,
    String? sendBy,
    String? senderId,
    String? type,
    Timestamp? createdAt,
  }) {
    return MessageModel(
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
}
