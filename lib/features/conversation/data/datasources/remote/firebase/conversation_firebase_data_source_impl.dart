import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:social_app/features/conversation/data/datasources/remote/conversation_remote_data_source.dart';
import 'package:social_app/features/conversation/data/mappers/conversation_mapper.dart';
import 'package:social_app/features/conversation/data/models/conversation_model.dart';
import 'package:social_app/features/conversation/domain/conversation_exeptions.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_type.dart';

class ConversationFirebaseDataSourceImpl
    implements ConversationRemoteDataSource {
  const ConversationFirebaseDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<ConversationModel> createConversation(
    List<String> participantIds,
  ) async {
    try {
      final docRef = await _firestore.collection('conversations').add({
        'participantIds': participantIds,
        'type': participantIds.length == 2
            ? ConversationType.direct.name
            : ConversationType.group.name,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage.createdAt': FieldValue.serverTimestamp(),
        'unreadCountMap': {},
        'name': '',
        'avatarUrl': null,
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
          .where('participantIds', arrayContains: currentUserId)
          .orderBy('lastMessage.createdAt', descending: true)
          .get();


      return querySnapshot.docs.map((doc) {
        final data = {...doc.data(), 'id': doc.id};
        return ConversationModel.fromJson(data);
      }).toList();
    } on FirebaseException catch (e, st) {
      debugPrint(
        'getConversations FirebaseException code=${e.code} message=${e.message}',
      );
      debugPrintStack(stackTrace: st);

      final fallbackSnapshot = await _firestore
          .collection('conversations')
          .where('participantIds', arrayContains: currentUserId)
          .get();

      final conversations = fallbackSnapshot.docs.map((doc) {
        final data = {...doc.data(), 'id': doc.id};
        return ConversationModel.fromJson(data);
      }).toList();

      conversations.sort((a, b) {
        final aTime = a.lastMessage?.createdAt ?? a.createdAt;
        final bTime = b.lastMessage?.createdAt ?? b.createdAt;
        return bTime.compareTo(aTime);
      });

      return conversations;
    } catch (e, st) {
      debugPrint('getConversations error: $e');
      debugPrintStack(stackTrace: st);

      throw ConversationExeptions(message: 'Failed to get conversations: $e');
    }
  }

  @override
  Future<ConversationModel> updateConversation(
    ConversationEntity conversation,
  ) async {
    try {
      final model = ConversationMapper.toModel(conversation);

      final docRef = _firestore.collection('conversations').doc(model.id);

      final data = model.toJson();
      await docRef.update(data);

      final updatedDoc = await docRef.get();
      final updatedData = {...?updatedDoc.data(), 'id': updatedDoc.id};
      return ConversationModel.fromJson(updatedData);
    } catch (e) {
      throw ConversationExeptions(message: 'Failed to update conversation: $e');
    }
  }
}
