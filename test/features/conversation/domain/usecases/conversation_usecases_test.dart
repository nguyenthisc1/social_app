import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/features/conversation/domain/conversation_params.dart';
import 'package:social_app/features/conversation/domain/usecases/create_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversations_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/update_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/watch_conversations_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../fixtures/conversation_fixtures.dart';

void main() {
  late MockConversationRepository mockConversationRepository;

  setUp(() {
    mockConversationRepository = MockConversationRepository();
  });

  group('CreateConversationUsecase', () {
    test(
      'Case 1: calls repository.createConversation with normalized participant ids',
      () async {
        final usecase = CreateConversationUsecase(mockConversationRepository);
        const normalizedParticipantIds = ['user_1', 'user_2'];
        when(
          mockConversationRepository.createConversation(
            normalizedParticipantIds,
          ),
        ).thenAnswer((_) async => fakeConversationEntity);

        final result = await usecase(
          const CreateConversationParams(
            participantIds: [' user_1 ', 'user_2', 'user_2'],
          ),
        );

        expect(result, fakeConversationEntity);
        verify(
          mockConversationRepository.createConversation(
            normalizedParticipantIds,
          ),
        ).called(1);
      },
    );

    test('Case 2: throws when participant list is empty', () async {
      final usecase = CreateConversationUsecase(mockConversationRepository);

      expect(
        () => usecase(const CreateConversationParams(participantIds: [])),
        throwsA(isA<ArgumentNotProvidedException>()),
      );
      verifyZeroInteractions(mockConversationRepository);
    });

    test(
      'Case 3: throws when there are fewer than 2 unique participants',
      () async {
        final usecase = CreateConversationUsecase(mockConversationRepository);

        expect(
          () => usecase(
            const CreateConversationParams(
              participantIds: ['user_1', 'user_1'],
            ),
          ),
          throwsA(isA<ArgumentInvalidException>()),
        );
        verifyZeroInteractions(mockConversationRepository);
      },
    );
  });

  group('GetConversationsUsecase', () {
    test('Case 1: returns repository conversations', () async {
      final usecase = GetConversationsUsecase(mockConversationRepository);
      when(
        mockConversationRepository.getConversations(fakeCurrentUserId),
      ).thenAnswer((_) async => [fakeConversationEntity]);

      final result = await usecase(fakeCurrentUserId);

      expect(result, [fakeConversationEntity]);
      verify(
        mockConversationRepository.getConversations(fakeCurrentUserId),
      ).called(1);
    });
  });

  group('GetConversationUsecase', () {
    test('Case 2: returns repository conversation by id', () async {
      final usecase = GetConversationUsecase(mockConversationRepository);
      when(
        mockConversationRepository.getConversation(fakeConversationEntity.id),
      ).thenAnswer((_) async => fakeConversationEntity);

      final result = await usecase(fakeConversationEntity.id);

      expect(result, fakeConversationEntity);
      verify(
        mockConversationRepository.getConversation(fakeConversationEntity.id),
      ).called(1);
    });
  });

  group('UpdateConversationsUsecase', () {
    test('Case 3: delegates to repository.updateConversation', () async {
      final usecase = UpdateConversationsUsecase(mockConversationRepository);
      when(
        mockConversationRepository.updateConversation(
          fakeUpdatedConversationEntity,
        ),
      ).thenAnswer((_) async => fakeUpdatedConversationEntity);

      final result = await usecase(fakeUpdatedConversationEntity);

      expect(result, fakeUpdatedConversationEntity);
      verify(
        mockConversationRepository.updateConversation(
          fakeUpdatedConversationEntity,
        ),
      ).called(1);
    });
  });

  group('WatchConversationsUsecase', () {
    test('Case 1: returns repository stream', () async {
      final controller = buildConversationEntityController();
      final usecase = WatchConversationsUsecase(mockConversationRepository);
      when(
        mockConversationRepository.watchConversations(fakeCurrentUserId),
      ).thenAnswer((_) => controller.stream);

      final stream = usecase(fakeCurrentUserId);

      controller.add([fakeConversationEntity]);

      await expectLater(
        stream,
        emitsInOrder([
          [fakeConversationEntity],
        ]),
      );
      await controller.close();
    });
  });
}
