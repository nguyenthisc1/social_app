import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/features/conversation/data/datasources/conversation_remote_data_source.dart';
import 'package:social_app/features/conversation/data/models/conversation_model.dart';
import 'package:social_app/features/conversation/domain/conversation_exeptions.dart';

class ConversationFirebaseDataSourceImpl
    implements ConversationRemoteDataSource {
  const ConversationFirebaseDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<ConversationModel> createConversation(List<String> memberIds) async {
    try {
      final docRef = await _firestore.collection('conversations').add({
        'memberIds': memberIds,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': null,
        'lastMessageAt': null,
        'lastMessageType': null,
        'lastSenderId': null,
        'unreadCountMap': {},
      });
      final docSnapshot = await docRef.get();

      final data = {
        ...?docSnapshot.data(),
        'id': docRef.id,
        'createdAt': (docSnapshot.data()?['createdAt'] ?? Timestamp.now()),
      };
      return ConversationModel.fromJson(data);
    } catch (e) {
      throw ConversationExeptions(message: 'Failed to create conversation: $e');
    }
  }

  @override
  Future<ConversationModel?> getConversation(String id) async {
    try {
      final doc = await _firestore.collection('conversations').doc(id).get();

      if (doc.data() == null) {
        throw ConversationExeptions(message: 'Conversation not fould.');
      }

      if (doc.exists && doc.data() != null) {
        final data = {...doc.data()!, 'id': doc.id};

        return ConversationModel.fromJson(data);
      }

      return null;
    } catch (e) {
      throw ConversationExeptions(message: 'Failed to get conversation: $e');
    }
  }

  @override
  Future<List<ConversationModel>> getConversations(String currentUserId) async {
    try {
      final querySnapshot = await _firestore
          .collection('conversations')
          .where('memberIds', arrayContains: currentUserId)
          .orderBy('lastMessageAt')
          .get();

      debugPrint('$querySnapshot');

      return querySnapshot.docs.map((doc) {
        final data = {...doc.data(), 'id': doc.id};
        return ConversationModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ConversationExeptions(message: 'Failed to get conversations: $e');
    }
  }

  @override
  Future<ConversationModel> updateConversation() {
    // TODO: implement updateConversation
    throw UnimplementedError();
  }
}
