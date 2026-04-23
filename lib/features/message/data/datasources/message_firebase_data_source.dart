import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/message/data/datasources/message_remote_data_source.dart';
import 'package:social_app/features/message/data/mappers/message_mapper.dart';
import 'package:social_app/features/message/data/models/message_model.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/message_exeptions.dart';

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
      throw MessageExeptions(message: e.toString());
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
        'fileName': messageModel.fileName,
        'fileUrl': messageModel.fileUrl,
        'senderId': currentUserId,
        'type': messageModel.type,
        'clientCreatedAt': messageModel.createdAt,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // update conversation item
      // Find the other user in the conversation (other than the current user)
      final conversationDoc = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .get();
      final memberIds = List<String>.from(conversationDoc['memberIds']);
      final otherUserId = memberIds.firstWhere((id) => id != currentUserId);

      await _firestore.collection('conversations').doc(conversationId).update({
        'lastMessage': messageModel.text,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'lastMessageType': 'text',
        'lastSenderId': currentUserId,
        'unreadCountMap.$otherUserId': FieldValue.increment(1),
        'unreadCountMap.$currentUserId': 0,
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
      throw MessageExeptions(message: e.toString());
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
      // Streams can't throw in this outerway, so we return a stream with the error.
      return Stream.error(e);
    }
  }
}
