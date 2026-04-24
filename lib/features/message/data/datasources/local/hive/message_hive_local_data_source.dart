import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:social_app/features/message/data/datasources/local/message_local_data_source.dart';
import 'package:social_app/features/message/data/models/message_model.dart';
import 'package:social_app/features/message/domain/message_exeptions.dart';

class MessageHiveLocalDataSource implements MessageLocalDataSource {
  static const _kMessagesBox = 'messages_box';

  String _conversationMessagesKey(String conversationId) =>
      'messages_$conversationId';

  Future<Box<dynamic>> _openBox() async {
    return Hive.isBoxOpen(_kMessagesBox)
        ? Hive.box<dynamic>(_kMessagesBox)
        : Hive.openBox<dynamic>(_kMessagesBox);
  }

  @override
  Future<void> cacheMessages(
    String conversationId,
    List<MessageModel> messages,
  ) async {
    try {
      final box = await _openBox();
      await box.put(
        _conversationMessagesKey(conversationId),
        messages.map(_serializeMessage).toList(),
      );
    } catch (e) {
      throw MessageExeptions(message: e.toString());
    }
  }

  @override
  Future<void> clearMessages(String conversationId) async {
    try {
      final box = await _openBox();
      await box.delete(_conversationMessagesKey(conversationId));
    } catch (e) {
      throw MessageExeptions(message: e.toString());
    }
  }

  @override
  Future<List<MessageModel>> getCachedMessages(String conversationId) async {
    try {
      final box = await _openBox();
      final raw = box.get(_conversationMessagesKey(conversationId));

      if (raw is! List) {
        return const [];
      }

      return raw
          .whereType<Map>()
          .map(
            (item) => MessageModel.fromJson(
              _deserializeMessage(Map<String, dynamic>.from(item)),
            ),
          )
          .toList();
    } catch (e) {
      throw MessageExeptions(message: e.toString());
    }
  }

  @override
  Future<void> upsertMessage(String conversationId, MessageModel message) async {
    try {
      final box = await _openBox();
      final currentMessages = await getCachedMessages(conversationId);
      final nextMessages = List<MessageModel>.from(currentMessages);
      final existingIndex = nextMessages.indexWhere(
        (item) =>
            item.id == message.id ||
            item.clientMessageId == message.clientMessageId,
      );

      if (existingIndex >= 0) {
        nextMessages[existingIndex] = message;
      } else {
        nextMessages.add(message);
      }

      nextMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      await box.put(
        _conversationMessagesKey(conversationId),
        nextMessages.map(_serializeMessage).toList(),
      );
    } catch (e) {
      throw MessageExeptions(message: e.toString());
    }
  }

  Map<String, dynamic> _serializeMessage(MessageModel model) {
    return {
      'clientMessageId': model.clientMessageId,
      'id': model.id,
      'conversationId': model.conversationId,
      'text': model.text,
      'fileName': model.fileName,
      'fileUrl': model.fileUrl,
      'senderId': model.senderId,
      'type': model.type,
      'status': model.status,
      'createdAt': model.createdAt.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> _deserializeMessage(Map<String, dynamic> json) {
    return {
      ...json,
      'createdAt': Timestamp.fromMillisecondsSinceEpoch(
        json['createdAt'] as int,
      ),
    };
  }
}
