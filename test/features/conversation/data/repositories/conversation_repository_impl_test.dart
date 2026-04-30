import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/features/conversation/data/repositories/conversation_repository_impl.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../fixtures/conversation_fixtures.dart';

void main() {
  late MockConversationRemoteDataSource mockRemoteDataSource;
  late MockConversationLocalDataSource mockLocalDataSource;
  late ConversationRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockConversationRemoteDataSource();
    mockLocalDataSource = MockConversationLocalDataSource();
    repository = ConversationRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('createConversation', () {
    test('Case 1: returns mapped entity from remote datasource', () async {
      final participantIds = [fakeCurrentUserId, fakeOtherUserId];
      when(
        mockRemoteDataSource.createConversation(participantIds),
      ).thenAnswer((_) async => fakeConversationModel);

      final result = await repository.createConversation(participantIds);

      expect(result, fakeConversationEntity);
      verify(mockRemoteDataSource.createConversation(participantIds)).called(1);
    });
  });

  group('getConversations', () {
    test(
      'Case 1: returns remote conversations and caches them on success',
      () async {
        final remoteModels = [fakeConversationModel];
        when(
          mockRemoteDataSource.getConversations(fakeCurrentUserId),
        ).thenAnswer((_) async => remoteModels);
        when(
          mockLocalDataSource.cacheConversations(
            fakeCurrentUserId,
            remoteModels,
          ),
        ).thenAnswer((_) async {});

        final result = await repository.getConversations(fakeCurrentUserId);

        expect(result, [fakeConversationEntity]);
        verify(
          mockRemoteDataSource.getConversations(fakeCurrentUserId),
        ).called(1);
        verify(
          mockLocalDataSource.cacheConversations(
            fakeCurrentUserId,
            remoteModels,
          ),
        ).called(1);
      },
    );

    test(
      'Case 1: falls back to cached conversations when remote fails',
      () async {
        final cachedModels = [fakeConversationModel];
        when(
          mockRemoteDataSource.getConversations(fakeCurrentUserId),
        ).thenThrow(Exception('remote failed'));
        when(
          mockLocalDataSource.getCachedConversations(fakeCurrentUserId),
        ).thenAnswer((_) async => cachedModels);

        final result = await repository.getConversations(fakeCurrentUserId);

        expect(result, [fakeConversationEntity]);
        verify(
          mockLocalDataSource.getCachedConversations(fakeCurrentUserId),
        ).called(1);
      },
    );
  });

  group('getConversation', () {
    test('Case 1: returns null when remote returns null', () async {
      when(
        mockRemoteDataSource.getConversation(fakeConversationEntity.id),
      ).thenAnswer((_) async => null);

      final result = await repository.getConversation(
        fakeConversationEntity.id,
      );

      expect(result, isNull);
    });

    test('Case 2: returns mapped entity when remote returns a model', () async {
      when(
        mockRemoteDataSource.getConversation(fakeConversationEntity.id),
      ).thenAnswer((_) async => fakeConversationModel);

      final result = await repository.getConversation(
        fakeConversationEntity.id,
      );

      expect(result, fakeConversationEntity);
    });
  });

  group('updateConversation', () {
    test(
      'Case 1: returns updated mapped entity from remote datasource',
      () async {
        when(
          mockRemoteDataSource.updateConversation(
            fakeUpdatedConversationEntity,
          ),
        ).thenAnswer((_) async => fakeConversationModel);

        final result = await repository.updateConversation(
          fakeUpdatedConversationEntity,
        );

        expect(result, fakeConversationEntity);
        verify(
          mockRemoteDataSource.updateConversation(
            fakeUpdatedConversationEntity,
          ),
        ).called(1);
      },
    );
  });

  group('watchConversations', () {
    test(
      'Case 1: emits cached conversations first, then remote stream updates',
      () async {
        final controller = buildConversationModelController();
        final cachedModels = [fakeConversationModel];
        final remoteModels = [fakeOlderConversationModel];
        when(
          mockLocalDataSource.getCachedConversations(fakeCurrentUserId),
        ).thenAnswer((_) async => cachedModels);
        when(
          mockRemoteDataSource.watchConversations(fakeCurrentUserId),
        ).thenAnswer((_) => controller.stream);
        when(
          mockLocalDataSource.cacheConversations(
            fakeCurrentUserId,
            remoteModels,
          ),
        ).thenAnswer((_) async {});

        final stream = repository.watchConversations(fakeCurrentUserId);

        controller.add(remoteModels);

        await expectLater(
          stream,
          emitsInOrder([
            [fakeConversationEntity],
            [fakeOlderConversationEntity],
          ]),
        );

        verify(
          mockLocalDataSource.cacheConversations(
            fakeCurrentUserId,
            remoteModels,
          ),
        ).called(1);
        await controller.close();
      },
    );
  });
}
