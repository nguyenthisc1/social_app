import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/conversation/data/seed/conversation_seed_data.dart';
import 'package:social_app/features/message/data/seed/message_seed_data.dart';

class FirebaseSeedService {
  FirebaseSeedService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<void> seedAllIfEmpty() async {
    await _seedConversationsIfEmpty();
    await _seedMessagesIfEmpty();
    await _firestore.waitForPendingWrites();
  }

  Future<void> _seedConversationsIfEmpty() async {
    final snapshot = await _firestore
        .collection('conversations')
        .limit(1)
        .get(const GetOptions(source: Source.server));
    if (snapshot.docs.isNotEmpty) {
      return;
    }

    final batch = _firestore.batch();

    for (final conversation in ConversationSeedData.conversations()) {
      final docRef = _firestore
          .collection('conversations')
          .doc(conversation.id);
      final data = Map<String, dynamic>.from(conversation.toJson())
        ..remove('id');
      batch.set(docRef, data);
    }
    await batch.commit();
  }

  Future<void> _seedMessagesIfEmpty() async {
    final snapshot = await _firestore
        .collection('messages')
        .limit(1)
        .get(const GetOptions(source: Source.server));
    if (snapshot.docs.isNotEmpty) {
      return;
    }

    final batch = _firestore.batch();

    for (final message in MessageSeedData.messages()) {
      final docRef = _firestore.collection('messages').doc(message.id);
      final data = Map<String, dynamic>.from(message.toJson())..remove('id');
      batch.set(docRef, data);
    }

    await batch.commit();
  }
}
