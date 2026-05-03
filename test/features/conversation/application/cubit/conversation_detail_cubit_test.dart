import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_detail_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_detail_state.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../fixtures/conversation_fixtures.dart';

void main() {
  late MockGetConversationUsecase mockGetConversationUsecase;
  late MockUpdateConversationsUsecase mockUpdateConversationsUsecase;
  late ConversationDetailCubit cubit;

  setUp(() {
    mockGetConversationUsecase = MockGetConversationUsecase();
    mockUpdateConversationsUsecase = MockUpdateConversationsUsecase();
    cubit = ConversationDetailCubit(
      getConversationUsecase: mockGetConversationUsecase,
      updateConversationsUsecase: mockUpdateConversationsUsecase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state is correct', () {
    expect(cubit.state.isLoading, false);
    expect(cubit.state.conversation, isNull);
    expect(cubit.state.errorMessage, isNull);
  });

  blocTest<ConversationDetailCubit, ConversationDetailState>(
    'getConversation emits loading then loaded conversation on success',
    build: () {
      when(
        mockGetConversationUsecase.call(fakeConversationEntity.id),
      ).thenAnswer((_) async => fakeConversationEntity);
      return cubit;
    },
    act: (cubit) => cubit.getConversation(fakeConversationEntity.id),
    expect: () => [
      isA<ConversationDetailState>().having(
        (s) => s.isLoading,
        'isLoading',
        true,
      ),
      isA<ConversationDetailState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having(
            (s) => s.conversation,
            'conversation',
            fakeConversationEntity,
          ),
    ],
  );

  blocTest<ConversationDetailCubit, ConversationDetailState>(
    'getConversation emits loading then error on failure',
    build: () {
      when(
        mockGetConversationUsecase.call(fakeConversationEntity.id),
      ).thenThrow(Exception('load detail failed'));
      return cubit;
    },
    act: (cubit) => cubit.getConversation(fakeConversationEntity.id),
    expect: () => [
      isA<ConversationDetailState>().having(
        (s) => s.isLoading,
        'isLoading',
        true,
      ),
      isA<ConversationDetailState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having(
            (s) => s.errorMessage,
            'errorMessage',
            contains('load detail failed'),
          ),
    ],
  );

  test(
    'updateUnreadCountConversation skips update when unread map is unchanged',
    () async {
      cubit.emit(cubit.state.copyWith(conversation: fakeConversationEntity));

      await cubit.updateUnreadCountConversation(fakeConversationEntity);

      verifyZeroInteractions(mockUpdateConversationsUsecase);
    },
  );

  blocTest<ConversationDetailCubit, ConversationDetailState>(
    'updateUnreadCountConversation emits updated conversation when unread map changes',
    build: () {
      cubit.emit(cubit.state.copyWith(conversation: fakeConversationEntity));
      when(
        mockUpdateConversationsUsecase.call(fakeUpdatedConversationEntity),
      ).thenAnswer((_) async => fakeUpdatedConversationEntity);
      return cubit;
    },
    act: (cubit) =>
        cubit.updateUnreadCountConversation(fakeUpdatedConversationEntity),
    expect: () => [
      isA<ConversationDetailState>().having(
        (s) => s.conversation,
        'conversation',
        fakeUpdatedConversationEntity,
      ),
    ],
  );

  test('clear resets state', () {
    cubit.emit(cubit.state.copyWith(conversation: fakeConversationEntity));

    cubit.clear();

    expect(cubit.state.conversation, isNull);
    expect(cubit.state.errorMessage, isNull);
    expect(cubit.state.isLoading, false);
  });
}
