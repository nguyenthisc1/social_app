import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/features/conversation/data/datasources/local/conversation_local_data_source.dart';
import 'package:social_app/features/conversation/data/models/conversation_last_message_model.dart';
import 'package:social_app/features/conversation/data/models/conversation_model.dart';
import 'package:social_app/features/conversation/domain/entites/unread_count.dart';

class ConversationHiveLocalDataSource implements ConversationLocalDataSource {
  static const _kConversationsBox = 'conversations_box';

  String _userConversationsKey(String userId) => 'conversations_$userId';

  Future<Box<dynamic>> _openBox() async {
    return Hive.isBoxOpen(_kConversationsBox)
        ? Hive.box<dynamic>(_kConversationsBox)
        : Hive.openBox<dynamic>(_kConversationsBox);
  }

  @override
  Future<void> cacheConversations(
    String userId,
    List<ConversationModel> conversations,
  ) async {
    try {
      final box = await _openBox();
      await box.put(
        _userConversationsKey(userId),
        conversations.map(_serializeConversation).toList(),
      );
    } catch (e) {
      throw CacheException(
        userMessage: 'Failed to cache conversations',
        debugMessage: 'Failed to cache conversations: $e',
        cause: e,
      );
    }
  }

  @override
  Future<void> clearConversations(String userId) async {
    try {
      final box = await _openBox();
      await box.delete(_userConversationsKey(userId));
    } catch (e) {
      throw CacheException(
        userMessage: 'Failed to clear cached conversations',
        debugMessage: 'Error clearing conversations for user $userId: $e',
        cause: e,
      );
    }
  }

  @override
  Future<List<ConversationModel>> getCachedConversations(String userId) async {
    try {
      final box = await _openBox();
      final raw = box.get(_userConversationsKey(userId));

      if (raw == null || raw is! List) {
        return const [];
      }

      final conversations = <ConversationModel>[];

      for (final item in raw) {
        try {
          if (item is! Map) {
            continue;
          }

          conversations.add(
            ConversationModel.fromJson(
              _deserializeConversation(Map<String, dynamic>.from(item)),
            ),
          );
        } catch (e, st) {
          debugPrint('Skip invalid cached conversation item: $e');
          debugPrintStack(stackTrace: st);
        }
      }

      return conversations;
    } catch (e) {
      throw CacheException(
        userMessage: 'Failed to load cached conversations',
        debugMessage: 'Error loading conversations for user $userId: $e',
        cause: e,
      );
    }
  }

  // Serializes ConversationModel to Map<String, dynamic> for Hive caching.
  Map<String, dynamic> _serializeConversation(ConversationModel model) {
    return {
      'id': model.id,
      'type': model.type,
      'participantIds': model.participantIds,
      'lastMessage': model.lastMessage == null
          ? null
          : {
              'id': model.lastMessage!.id,
              'senderId': model.lastMessage!.senderId,
              'type': model.lastMessage!.type,
              'text': model.lastMessage!.text,
              'mediaUrl': model.lastMessage!.mediaUrl,
              'mediaType': model.lastMessage!.mediaType,
              'isDeleted': model.lastMessage!.isDeleted,
              'createdAt': model.lastMessage!.createdAt.millisecondsSinceEpoch,
            },
      'createdAt': model.createdAt.millisecondsSinceEpoch,
      'name': model.name,
      'avatarUrl': model.avatarUrl,
      'unreadCountMap': model.unreadCountMap.map(
        (key, value) => MapEntry(key, {
          'count': value.count,
          'lastReadAt': value.lastReadAt?.millisecondsSinceEpoch,
          'lastReadMessageId': value.lastReadMessageId,
        }),
      ),
    };
  }

  // Deserializes cached Map<String, dynamic> to a format accepted by ConversationModel.fromJson
  Map<String, dynamic> _deserializeConversation(Map<String, dynamic> json) {
    final unreadCountMapRaw = json['unreadCountMap'];

    return {
      ...json,
      // lastMessage: attempt deserialization only if present, using fromJson if Map
      'lastMessage': (json['lastMessage'] is Map)
          ? ConversationLastMessageModel.fromJson(
              Map<String, dynamic>.from(json['lastMessage'] as Map),
            )
          : (json['lastMessage'] is ConversationLastMessageModel)
          ? json['lastMessage']
          : null,
      // Only handle 'createdAt' (no lastMessageAt/lastSenderId/lastMessageType)
      'createdAt': json['createdAt'] is Timestamp
          ? json['createdAt']
          : Timestamp.fromMillisecondsSinceEpoch(
              (json['createdAt'] as int?) ??
                  DateTime.now().millisecondsSinceEpoch,
            ),
      'participantIds': List<String>.from(
        (json['participantIds'] as List?) ?? const <String>[],
      ),
      'unreadCountMap': unreadCountMapRaw is Map
          ? unreadCountMapRaw.map(
              (key, value) =>
                  MapEntry(key.toString(), _deserializeUnreadCount(value)),
            )
          : <String, UnreadCount>{},
    };
  }

  UnreadCount _deserializeUnreadCount(dynamic value) {
    if (value is UnreadCount) return value;
    if (value is Map<String, dynamic>) return UnreadCount.fromJson(value);
    if (value is Map) {
      return UnreadCount.fromJson(Map<String, dynamic>.from(value));
    }
    return const UnreadCount(count: 0);
  }
}
