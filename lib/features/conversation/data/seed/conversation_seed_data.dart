
import 'package:social_app/core/utils/time_formatter.dart';
import 'package:social_app/features/conversation/data/models/conversation_last_message_model.dart';
import 'package:social_app/features/conversation/data/models/conversation_model.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_type.dart';
import 'package:social_app/features/conversation/domain/entites/unread_count.dart';
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
        type: ConversationType.direct.name,
        participantIds: const [UserSeedData.userOneId, UserSeedData.userTwoId],
        lastMessage: ConversationLastMessageModel(
          id: 'message_alice_bob_4',
          senderId: UserSeedData.userTwoId,
          type: 'text',
          text: 'Perfect, see you at 8.',
          mediaUrl: null,
          mediaType: null,
          isDeleted: false,
          createdAt: TimeFormatter.timestamp(2026, 4, 21, 13, 18),
        ),
        unreadCountMap: {
          UserSeedData.userOneId: const UnreadCount(count: 0),
          UserSeedData.userTwoId: const UnreadCount(count: 1),
        },
        createdAt: TimeFormatter.timestamp(2026, 4, 21, 13, 0),
        name: 'Alice & Bob',
        avatarUrl: null,
      ),
      ConversationModel(
        id: aliceCharlieId,
        type: ConversationType.direct.name,
        participantIds: const [
          UserSeedData.userOneId,
          UserSeedData.userThreeId,
        ],
        lastMessage: ConversationLastMessageModel(
          id: 'message_alice_charlie_4',
          senderId: UserSeedData.userThreeId,
          type: 'text',
          text: 'I pushed the latest draft.',
          mediaUrl: null,
          mediaType: null,
          isDeleted: false,
          createdAt: TimeFormatter.timestamp(2026, 4, 21, 19, 52),
        ),
        unreadCountMap: {
          UserSeedData.userOneId: const UnreadCount(count: 2),
          UserSeedData.userThreeId: const UnreadCount(count: 0),
        },
        createdAt: TimeFormatter.timestamp(2026, 4, 21, 19, 30),
        name: 'Alice & Charlie',
        avatarUrl: null,
      ),
      ConversationModel(
        id: bobDianaId,
        type: ConversationType.direct.name,
        participantIds: const [
          UserSeedData.userTwoId,
          UserSeedData.userThreeId,
        ],
        lastMessage: ConversationLastMessageModel(
          id: 'message_bob_diana_2',
          senderId: UserSeedData.userThreeId,
          type: 'image',
          text: '',
          mediaUrl: 'https://example.com/files/cover-preview.png',
          mediaType: 'image/png',
          isDeleted: false,
          createdAt: TimeFormatter.timestamp(2026, 4, 22, 8, 12),
        ),
        unreadCountMap: {
          UserSeedData.userTwoId: const UnreadCount(count: 1),
          UserSeedData.userThreeId: const UnreadCount(count: 0),
        },
        createdAt: TimeFormatter.timestamp(2026, 4, 22, 7, 45),
        name: 'Bob & Diana',
        avatarUrl: null,
      ),
    ];
  }
}
