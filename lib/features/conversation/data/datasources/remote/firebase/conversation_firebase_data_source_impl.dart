import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:social_app/features/conversation/data/datasources/remote/conversation_remote_data_source.dart';
import 'package:social_app/features/conversation/data/mappers/conversation_mapper.dart';
import 'package:social_app/features/conversation/data/models/conversation_model.dart';
import 'package:social_app/features/conversation/domain/conversation_exceptions.dart';
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
    } on FirebaseException catch (e) {
      throw ConversationCreateException(
        userMessage: 'Unable to create conversation.',
        debugMessage: 'Firestore create conversation failed.',
        cause: e,
        metadata: {'firebaseCode': e.code},
      );
    } catch (e) {
      throw ConversationCreateException(
        cause: e,
        debugMessage: 'Unexpected error while creating conversation.',
      );
    }
  }

  @override
  Future<ConversationModel?> getConversation(String id) async {
    try {
      final doc = await _firestore.collection('conversations').doc(id).get();

      if (doc.data() == null) {
        throw ConversationLoadException(
          userMessage: 'Conversation not found.',
          debugMessage: 'Conversation document is null.',
        );
      }

      if (doc.exists && doc.data() != null) {
        final data = {...doc.data()!, 'id': doc.id};

        return ConversationModel.fromJson(data);
      }

      return null;
    } catch (e) {
      throw ConversationLoadException(
        userMessage: 'Failed to get conversation.',
        debugMessage: 'Failed to get conversation: $e',
        cause: e,
      );
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

      throw ConversationLoadException(
        userMessage: 'Failed to get conversations.',
        debugMessage: 'Failed to get conversations: $e',
        cause: e,
      );
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
      throw ConversationWatchException(
        userMessage: 'Failed to update conversation.',
        debugMessage: 'Failed to update conversation: $e',
        cause: e,
      );
    }
  }

  @override
  Stream<List<ConversationModel>> watchConversations(String currentUserId) {
    try {
      return _firestore
          .collection('conversations')
          .where('participantIds', arrayContains: currentUserId)
          .orderBy('lastMessage.createdAt', descending: true)
          .snapshots()
          .map(
            (querySnapshot) => querySnapshot.docs.map((doc) {
              final rawData = doc.data();
              final data = {...rawData, 'id': doc.id};
              return ConversationModel.fromJson(data);
            }).toList(),
          );
    } catch (e, st) {
      debugPrint('getConversations error: $e');
      debugPrintStack(stackTrace: st);

      throw ConversationExeptions(message: 'Failed to get conversations: $e');
    }
  }
}
