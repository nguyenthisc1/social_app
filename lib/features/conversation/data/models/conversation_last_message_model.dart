import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ConversationLastMessageModel extends Equatable {
  final String id;
  final String senderId;
  final String type;
  final String? text;
  final List<String> mediaUrls;
  final String? mediaType;
  final bool isDeleted;
  final Timestamp createdAt;

  const ConversationLastMessageModel({
    required this.id,
    required this.senderId,
    required this.type,
    this.text,
    this.mediaUrls = const [],
    required this.createdAt,
    this.mediaType,
    this.isDeleted = false,
  });

  String? get mediaUrl => mediaUrls.isNotEmpty ? mediaUrls.first : null;

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

  factory ConversationLastMessageModel.fromJson(Map<String, dynamic> json) {
    final parsedMediaUrls = json['mediaUrls'] is List
        ? List<String>.from(
            (json['mediaUrls'] as List).whereType<Object?>().map(
              (item) => item.toString(),
            ),
          )
        : (json['mediaUrl']?.toString().isNotEmpty == true
              ? [json['mediaUrl'].toString()]
              : const <String>[]);

    return ConversationLastMessageModel(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      type: json['type']?.toString() ?? 'text',
      text: json['text'],
      mediaUrls: parsedMediaUrls,
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
      'mediaUrls': mediaUrls,
      'mediaType': mediaType,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
    };
  }
}
