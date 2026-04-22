import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/conversation/data/seed/conversation_seed_data.dart';
import 'package:social_app/features/message/data/models/message_model.dart';
import 'package:social_app/features/user/data/seed/user_seed_data.dart';

class MessageSeedData {
  MessageSeedData._();

  static List<MessageModel> messages() {
    return [
      MessageModel(
        id: 'message_alice_bob_1',
        conversationId: ConversationSeedData.aliceBobId,
        text: 'Hey Bob, are you free tonight?',
        fileName: null,
        fileUrl: null,
        senderId: UserSeedData.userOneId,
        type: 'text',
        createdAt: _timestamp(2026, 4, 21, 13, 2),
      ),
      MessageModel(
        id: 'message_alice_bob_2',
        conversationId: ConversationSeedData.aliceBobId,
        text: 'Yes, what time works for you?',
        fileName: null,
        fileUrl: null,
        senderId: UserSeedData.userTwoId,
        type: 'text',
        createdAt: _timestamp(2026, 4, 21, 13, 7),
      ),
      MessageModel(
        id: 'message_alice_bob_3',
        conversationId: ConversationSeedData.aliceBobId,
        text: 'Let\'s do 8 PM near the old cafe.',
        fileName: null,
        fileUrl: null,
        senderId: UserSeedData.userOneId,
        type: 'text',
        createdAt: _timestamp(2026, 4, 21, 13, 12),
      ),
      MessageModel(
        id: 'message_alice_bob_4',
        conversationId: ConversationSeedData.aliceBobId,
        text: 'Perfect, see you at 8.',
        fileName: null,
        fileUrl: null,
        senderId: UserSeedData.userTwoId,
        type: 'text',
        createdAt: _timestamp(2026, 4, 21, 13, 18),
      ),
      MessageModel(
        id: 'message_alice_charlie_1',
        conversationId: ConversationSeedData.aliceCharlieId,
        text: 'Did you get a chance to review the wireframe?',
        fileName: null,
        fileUrl: null,
        senderId: UserSeedData.userOneId,
        type: 'text',
        createdAt: _timestamp(2026, 4, 21, 19, 31),
      ),
      MessageModel(
        id: 'message_alice_charlie_2',
        conversationId: ConversationSeedData.aliceCharlieId,
        text: 'Almost done. I\'m fixing the spacing issue first.',
        fileName: null,
        fileUrl: null,
        senderId: UserSeedData.userThreeId,
        type: 'text',
        createdAt: _timestamp(2026, 4, 21, 19, 39),
      ),
      MessageModel(
        id: 'message_alice_charlie_3',
        conversationId: ConversationSeedData.aliceCharlieId,
        text: 'Nice, send it when ready.',
        fileName: null,
        fileUrl: null,
        senderId: UserSeedData.userOneId,
        type: 'text',
        createdAt: _timestamp(2026, 4, 21, 19, 45),
      ),
      MessageModel(
        id: 'message_alice_charlie_4',
        conversationId: ConversationSeedData.aliceCharlieId,
        text: 'I pushed the latest draft.',
        fileName: null,
        fileUrl: null,
        senderId: UserSeedData.userThreeId,
        type: 'text',
        createdAt: _timestamp(2026, 4, 21, 19, 52),
      ),
      MessageModel(
        id: 'message_bob_diana_1',
        conversationId: ConversationSeedData.bobDianaId,
        text: 'Can you send me the final cover image?',
        fileName: null,
        fileUrl: null,
        senderId: UserSeedData.userTwoId,
        type: 'text',
        createdAt: _timestamp(2026, 4, 22, 7, 47),
      ),
      MessageModel(
        id: 'message_bob_diana_2',
        conversationId: ConversationSeedData.bobDianaId,
        text: null,
        fileName: 'cover-preview.png',
        fileUrl: 'https://example.com/files/cover-preview.png',
        senderId: UserSeedData.userThreeId,
        type: 'image',
        createdAt: _timestamp(2026, 4, 22, 8, 12),
      ),
    ];
  }

  static Timestamp _timestamp(int year, int month, int day, int hour, int minute) {
    return Timestamp.fromDate(
      DateTime(year, month, day, hour, minute),
    );
  }
}
