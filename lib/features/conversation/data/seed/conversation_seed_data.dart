import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/conversation/data/models/conversation_model.dart';
import 'package:social_app/features/user/data/seed/user_seed_data.dart';

class ConversationSeedData {
  ConversationSeedData._();

  static const aliceBobId = 'conversation_alice_bob';
  static const aliceCharlieId = 'conversation_alice_charlie';
  static const bobDianaId = 'conversation_bob_diana';

  static List<ConversationModel> conversations() {
    return [
      ConversationModel(
        id: aliceBobId,
        memberIds: const [UserSeedData.userOneId, UserSeedData.userTwoId],
        lastMessage: 'Perfect, see you at 8.',
        lastMessageAt: _timestamp(2026, 4, 21, 13, 18),
        lastMessageType: 'text',
        lastSenderId: UserSeedData.userTwoId,
        unreadCountMap: const {
          UserSeedData.userOneId: 0,
          UserSeedData.userTwoId: 1,
        },
        createdAt: _timestamp(2026, 4, 21, 13, 0),
      ),
      ConversationModel(
        id: aliceCharlieId,
        memberIds: const [UserSeedData.userOneId, UserSeedData.userThreeId],
        lastMessage: 'I pushed the latest draft.',
        lastMessageAt: _timestamp(2026, 4, 21, 19, 52),
        lastMessageType: 'text',
        lastSenderId: UserSeedData.userThreeId,
        unreadCountMap: const {
          UserSeedData.userOneId: 2,
          UserSeedData.userThreeId: 0,
        },
        createdAt: _timestamp(2026, 4, 21, 19, 30),
      ),
      ConversationModel(
        id: bobDianaId,
        memberIds: const [UserSeedData.userTwoId, UserSeedData.userThreeId],
        lastMessage: 'Image sent',
        lastMessageAt: _timestamp(2026, 4, 22, 8, 12),
        lastMessageType: 'image',
        lastSenderId: UserSeedData.userThreeId,
        unreadCountMap: const {
          UserSeedData.userTwoId: 1,
          UserSeedData.userThreeId: 0,
        },
        createdAt: _timestamp(2026, 4, 22, 7, 45),
      ),
    ];
  }

  static Timestamp _timestamp(int year, int month, int day, int hour, int minute) {
    return Timestamp.fromDate(
      DateTime(year, month, day, hour, minute),
    );
  }
}
