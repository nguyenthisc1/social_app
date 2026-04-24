import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:social_app/features/conversation/data/datasources/local/conversation_local_data_source.dart';
import 'package:social_app/features/conversation/data/models/conversation_model.dart';
import 'package:social_app/features/conversation/domain/conversation_exeptions.dart';

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
      throw ConversationExeptions(message: e.toString());
    }
  }

  @override
  Future<void> clearConversations(String userId) async {
    try {
      final box = await _openBox();
      await box.delete(_userConversationsKey(userId));
    } catch (e) {
      throw ConversationExeptions(message: e.toString());
    }
  }

  @override
  Future<List<ConversationModel>> getCachedConversations(String userId) async {
    try {
      final box = await _openBox();
      final raw = box.get(_userConversationsKey(userId));

      if (raw is! List) {
        return const [];
      }

      return raw
          .whereType<Map>()
          .map(
            (item) => ConversationModel.fromJson(
              _deserializeConversation(Map<String, dynamic>.from(item)),
            ),
          )
          .toList();
    } catch (e) {
      throw ConversationExeptions(message: e.toString());
    }
  }

  Map<String, dynamic> _serializeConversation(ConversationModel model) {
    return {
      'id': model.id,
      'lastMessage': model.lastMessage,
      'lastMessageAt': model.lastMessageAt?.millisecondsSinceEpoch,
      'lastMessageType': model.lastMessageType,
      'lastSenderId': model.lastSenderId,
      'memberIds': model.memberIds,
      'unreadCountMap': model.unreadCountMap,
      'createdAt': model.createdAt.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> _deserializeConversation(Map<String, dynamic> json) {
    return {
      ...json,
      'lastMessageAt': json['lastMessageAt'] == null
          ? null
          : Timestamp.fromMillisecondsSinceEpoch(json['lastMessageAt'] as int),
      'createdAt': Timestamp.fromMillisecondsSinceEpoch(
        json['createdAt'] as int,
      ),
      'memberIds': List<String>.from(json['memberIds'] as List),
      'unreadCountMap': Map<String, int>.from(
        (json['unreadCountMap'] as Map).map(
          (key, value) => MapEntry(key.toString(), value as int),
        ),
      ),
    };
  }
}
