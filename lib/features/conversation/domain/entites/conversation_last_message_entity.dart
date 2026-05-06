import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/features/message/domain/entites/message_type.dart';

class ConversationLastMessageEntity extends Equatable {
  final String id;
  final String senderId;
  final MessageType type;
  final String? text;
  final List<String> mediaUrls;
  final String? mediaType;
  final bool isDeleted;
  final Timestamp createdAt;

  const ConversationLastMessageEntity({
    required this.id,
    required this.senderId,
    required this.type,
    this.text,
    this.mediaUrls = const [],
    this.mediaType,
    this.isDeleted = false,
    required this.createdAt,
  });

  String? get mediaUrl => mediaUrls.isNotEmpty ? mediaUrls.first : null;
  int get mediaCount => mediaUrls.length;

  @override
  List<Object?> get props => [
    id,
    senderId,
    type,
    text,
    mediaUrls,
    mediaType,
    isDeleted,
    createdAt,
  ];

  ConversationLastMessageEntity copyWith({
    String? id,
    String? senderId,
    MessageType? type,
    String? text,
    List<String>? mediaUrls,
    String? mediaType,
    bool? isDeleted,
    Timestamp? createdAt,
  }) {
    return ConversationLastMessageEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      text: text ?? this.text,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      mediaType: mediaType ?? this.mediaType,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
