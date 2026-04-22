import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/message/data/datasources/message_remote_data_source.dart';
import 'package:social_app/features/message/data/models/message_model.dart';

class MessageFirebaseDataSource implements MessageRemoteDataSource {
  const MessageFirebaseDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<List<MessageModel>> getMessagesByConversation(
    String conversationId,
  ) async {
    final querySnapshot = await _firestore
        .collection('messages')
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = {...doc.data(), 'id': doc.id};
      return MessageModel.fromJson(data);
    }).toList();
  }

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String text,
    required String currentUserId,
  }) async {
    final docRef = await _firestore.collection('messages').add({
      'conversationId': conversationId,
      'text': text,
      'finalName': null,
      'fileUrl': null,
      'senderId': currentUserId,
      'type': 'text',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final docSnapshot = await docRef.get();

    final data = {
      ...?docSnapshot.data(),
      'id': docRef.id,
      'createdAt': (docSnapshot.data()?['createdAt'] ?? Timestamp.now()),
    };

    return MessageModel.fromJson(data);
  }
}
