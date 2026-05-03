import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_state.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/entites/unread_count.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../fixtures/conversation_fixtures.dart';

void main() {
  late MockGetConversationsUsecase mockGetConversationsUsecase;
  late MockConversationLocalDataSource mockConversationLocalDataSource;
  late MockWatchConversationsUsecase mockWatchConversationsUsecase;
  late ConversationCubit cubit;

  setUp(() {
    mockGetConversationsUsecase = MockGetConversationsUsecase();
    mockConversationLocalDataSource = MockConversationLocalDataSource();
    mockWatchConversationsUsecase = MockWatchConversationsUsecase();

    cubit = ConversationCubit(
      getConversationsUsecase: mockGetConversationsUsecase,
      conversationLocalDataSource: mockConversationLocalDataSource,
      watchConversationsUsecase: mockWatchConversationsUsecase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state is correct', () {
    expect(cubit.state.isLoading, false);
    expect(cubit.state.errorMessage, null);
    expect(cubit.state.conversations, isEmpty);
    expect(cubit.state.currentUserId, '');
  });

  blocTest<ConversationCubit, ConversationState>(
    'getConversations does nothing when currentUserId is empty',
    build: () => cubit,
    act: (cubit) => cubit.getConversations(),
    expect: () => [
      isA<ConversationState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.currentUserId, 'currentUserId', ''),
    ],
    verify: (_) {
      verifyNever(mockGetConversationsUsecase.call(fakeCurrentUserId));
    },
  );

  blocTest<ConversationCubit, ConversationState>(
    'getConversations emits loading then loaded conversations on success',
    build: () {
      cubit.emit(cubit.state.copyWith(currentUserId: fakeCurrentUserId));
      when(
        mockGetConversationsUsecase.call(fakeCurrentUserId),
      ).thenAnswer((_) async => [fakeConversationEntity]);
      return cubit;
    },
    act: (cubit) => cubit.getConversations(),
    expect: () => [
      isA<ConversationState>()
          .having((s) => s.isLoading, 'isLoading', true)
          .having((s) => s.errorMessage, 'errorMessage', isNull),
      isA<ConversationState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.conversations, 'conversations', [
            fakeConversationEntity,
          ]),
    ],
  );

  blocTest<ConversationCubit, ConversationState>(
    'getConversations emits loading then error on failure',
    build: () {
      cubit.emit(cubit.state.copyWith(currentUserId: fakeCurrentUserId));
      when(
        mockGetConversationsUsecase.call(fakeCurrentUserId),
      ).thenThrow(Exception('load failed'));
      return cubit;
    },
    act: (cubit) => cubit.getConversations(),
    expect: () => [
      isA<ConversationState>().having((s) => s.isLoading, 'isLoading', true),
      isA<ConversationState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having(
            (s) => s.errorMessage,
            'errorMessage',
            contains('load failed'),
          ),
    ],
  );

  blocTest<ConversationCubit, ConversationState>(
    'updateNewMessageConversationLocal updates last message, unread counts, and sorting',
    build: () {
      cubit.emit(
        cubit.state.copyWith(
          currentUserId: fakeCurrentUserId,
          conversations: [fakeConversationEntity, fakeOlderConversationEntity],
        ),
      );
      return cubit;
    },
    act: (cubit) => cubit.updateNewMessageConversationLocal(fakeMessageEntity),
    expect: () => [
      isA<ConversationState>().having(
        (s) {
          final updated = s.conversations.first;
          return updated.id;
        },
        'first conversation id',
        fakeOlderConversationEntity.id,
      ),
    ],
    verify: (_) {
      final updated = cubit.state.conversations.firstWhere(
        (c) => c.id == fakeOlderConversationEntity.id,
      );
      expect(updated.lastMessage?.id, fakeMessageEntity.id);
      expect(
        updated.unreadCountMap[fakeThirdUserId],
        const UnreadCount(count: 1),
      );
      expect(
        updated.unreadCountMap[fakeCurrentUserId],
        const UnreadCount(count: 0),
      );
    },
  );

  blocTest<ConversationCubit, ConversationState>(
    'updateLocalUnreadCountConversation resets unread count for current user',
    build: () {
      cubit.emit(
        cubit.state.copyWith(
          currentUserId: fakeCurrentUserId,
          conversations: [fakeConversationEntity],
        ),
      );
      return cubit;
    },
    act: (cubit) => cubit.updateLocalUnreadCountConversation(
      fakeCurrentUserId,
      fakeConversationEntity,
    ),
    expect: () => [isA<ConversationState>()],
    verify: (_) {
      expect(
        cubit.state.conversations.first.unreadCountMap[fakeCurrentUserId],
        const UnreadCount(count: 0),
      );
    },
  );

  test(
    'getTotalUnreadCount counts conversations with unread messages only',
    () {
      final state = cubit.state.copyWith(
        currentUserId: fakeCurrentUserId,
        conversations: [fakeConversationEntity, fakeOlderConversationEntity],
      );

      final result = cubit.getTotalUnreadCount(state);

      expect(result, 1);
    },
  );

  test('initialize loads cache and starts watching remote stream', () async {
    final controller = StreamController<List<ConversationEntity>>();
    when(
      mockConversationLocalDataSource.getCachedConversations(fakeCurrentUserId),
    ).thenAnswer((_) async => [fakeConversationModel]);
    when(
      mockWatchConversationsUsecase.call(fakeCurrentUserId),
    ).thenAnswer((_) => controller.stream);

    await cubit.initialize(fakeCurrentUserId);

    expect(cubit.state.currentUserId, fakeCurrentUserId);
    expect(cubit.state.conversations, [fakeConversationEntity]);
    verify(
      mockConversationLocalDataSource.getCachedConversations(fakeCurrentUserId),
    ).called(1);
    verify(mockWatchConversationsUsecase.call(fakeCurrentUserId)).called(1);
    await controller.close();
  });
}
