import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/message/data/datasources/remote/message_remote_data_source.dart';
import 'package:social_app/features/message/data/mappers/message_mapper.dart';
import 'package:social_app/features/message/data/models/message_model.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/message_exceptions.dart'
    show MessageLoadException, MessageSendException, MessageWatchException;

class MessageFirebaseDataSource implements MessageRemoteDataSource {
  const MessageFirebaseDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<List<MessageModel>> getMessagesByConversation(
    String conversationId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('messages')
          .where('conversationId', isEqualTo: conversationId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = {...doc.data(), 'id': doc.id};
        return MessageModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw MessageLoadException(
        debugMessage: 'Failed to load messages for conversationId=$conversationId: $e',
        cause: e,
      );
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required MessageEntity message,
    required String currentUserId,
  }) async {
    try {
      final messageModel = MessageMapper.toModel(message);

      final docRef = await _firestore.collection('messages').add({
        'clientMessageId': messageModel.clientMessageId,
        'conversationId': conversationId,
        'text': messageModel.text,
        'senderId': currentUserId,
        'type': messageModel.type,
        'status': 'sent',
        'isDeleted': messageModel.isDeleted,
        'replyTo': messageModel.replyTo,
        'reactions': messageModel.reactions,
        'mediaUrl': messageModel.mediaUrl,
        'mediaType': messageModel.mediaType,
        'clientCreatedAt': messageModel.createdAt,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // update conversation item
      // Find the other user in the conversation (other than the current user)
      final conversationDoc = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .get();
      final participantIds = List<String>.from(
        conversationDoc['participantIds'],
      );
      final otherUserId = participantIds.firstWhere(
        (id) => id != currentUserId,
        orElse: () => currentUserId,
      );

      await _firestore.collection('conversations').doc(conversationId).update({
        'lastMessage.id': docRef.id,
        'lastMessage.senderId': currentUserId,
        'lastMessage.type': messageModel.type,
        'lastMessage.text': messageModel.text,
        'lastMessage.mediaUrl': messageModel.mediaUrl,
        'lastMessage.mediaType': messageModel.mediaType,
        'lastMessage.isDeleted': messageModel.isDeleted,
        'lastMessage.createdAt': FieldValue.serverTimestamp(),

        'unreadCountMap.$otherUserId.count': FieldValue.increment(1),
        // 'unreadCountMap.$otherUserId.lastReadAt': FieldValue.serverTimestamp(),
        // 'unreadCountMap.$otherUserId.lastReadMessageId': FieldValue,
        'unreadCountMap.$currentUserId.count': 0,
        // 'unreadCountMap.$currentUserId.lastReadAt':
        //     FieldValue.serverTimestamp(),
        // 'unreadCountMap.$currentUserId.lastReadMessageId': FieldValue,
      });

      final docSnapshot = await docRef.get();

      final data = {
        ...?docSnapshot.data(),
        'id': docRef.id,
        'status': 'sent',
        'createdAt': (docSnapshot.data()?['createdAt'] ?? Timestamp.now()),
      };

      return MessageModel.fromJson(data);
    } catch (e) {
      throw MessageSendException(
        debugMessage: 'Failed to send message to conversationId=$conversationId: $e',
        cause: e,
      );
    }
  }

  @override
  Stream<List<MessageModel>> watchMessagesByConversation(
    String conversationId,
  ) {
    try {
      return _firestore
          .collection('messages')
          .where('conversationId', isEqualTo: conversationId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (querySnapshot) => querySnapshot.docs.map((doc) {
              final rawData = doc.data();
              final data = {
                ...rawData,
                'id': doc.id,
                'createdAt':
                    rawData['createdAt'] ??
                    rawData['clientCreatedAt'] ??
                    Timestamp.now(),
              };
              return MessageModel.fromJson(data);
            }).toList(),
          );
    } catch (e) {
      return Stream.error(
        MessageWatchException(
          debugMessage: 'Failed to watch messages for conversationId=$conversationId: $e',
          cause: e,
        ),
      );
    }
  }
}
