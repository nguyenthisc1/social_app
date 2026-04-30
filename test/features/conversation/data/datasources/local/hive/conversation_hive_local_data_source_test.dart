import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:social_app/features/conversation/data/datasources/local/hive/conversation_hive_local_data_source.dart';

import '../../../../fixtures/conversation_fixtures.dart';

void main() {
  late ConversationHiveLocalDataSource dataSource;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('conversation_hive_test_');
    Hive.init(tempDir.path);
    dataSource = ConversationHiveLocalDataSource();
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk('conversations_box');
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
    'cacheConversations -> getCachedConversations returns saved models',
    () async {
      await dataSource.cacheConversations(fakeCurrentUserId, [
        fakeConversationModel,
        fakeOlderConversationModel,
      ]);

      final result = await dataSource.getCachedConversations(fakeCurrentUserId);

      expect(result, [fakeConversationModel, fakeOlderConversationModel]);
    },
  );

  test(
    'getCachedConversations skips invalid cached items and returns valid ones',
    () async {
      final box = await Hive.openBox<dynamic>('conversations_box');
      final validCachedConversation = {
        'id': fakeConversationModel.id,
        'type': fakeConversationModel.type,
        'participantIds': fakeConversationModel.participantIds,
        'lastMessage': {
          'id': fakeLastMessageModel.id,
          'senderId': fakeLastMessageModel.senderId,
          'type': fakeLastMessageModel.type,
          'text': fakeLastMessageModel.text,
          'mediaUrl': fakeLastMessageModel.mediaUrl,
          'mediaType': fakeLastMessageModel.mediaType,
          'isDeleted': fakeLastMessageModel.isDeleted,
          'createdAt': fakeLastMessageModel.createdAt.millisecondsSinceEpoch,
        },
        'createdAt': fakeConversationModel.createdAt.millisecondsSinceEpoch,
        'name': fakeConversationModel.name,
        'avatarUrl': fakeConversationModel.avatarUrl,
        'unreadCountMap': {
          fakeCurrentUserId: {
            'count': 1,
            'lastReadAt': null,
            'lastReadMessageId': null,
          },
          fakeOtherUserId: {
            'count': 0,
            'lastReadAt': null,
            'lastReadMessageId': null,
          },
        },
      };
      await box.put('conversations_$fakeCurrentUserId', [
        validCachedConversation,
        'invalid-item',
        {'id': 'broken', 'participantIds': 'not-a-list'},
      ]);

      final result = await dataSource.getCachedConversations(fakeCurrentUserId);

      expect(result, [fakeConversationModel]);
    },
  );

  test(
    'clearConversations removes cached conversations for the user',
    () async {
      await dataSource.cacheConversations(fakeCurrentUserId, [
        fakeConversationModel,
      ]);

      await dataSource.clearConversations(fakeCurrentUserId);

      final result = await dataSource.getCachedConversations(fakeCurrentUserId);

      expect(result, isEmpty);
    },
  );
}
