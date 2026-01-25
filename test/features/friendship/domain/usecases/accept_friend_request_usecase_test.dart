import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/usecases/accept_friend_request_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late AcceptFriendRequestUsecase usecase;
  late MockFriendshipRepository mockFriendshipRepository;

  setUp(() {
    mockFriendshipRepository = MockFriendshipRepository();
    usecase = AcceptFriendRequestUsecase(repository: mockFriendshipRepository);
  });

  const testRequestId = 'friendship123';

  group('AcceptFriendRequestUsecase', () {
    test('should accept friend request from repository', () async {
      // arrange
      const response = FriendshipResponseEntity(
        success: true,
        message: 'Friend request accepted successfully',
      );
      when(
        mockFriendshipRepository.acceptRequest(
          requestId: anyNamed('requestId'),
        ),
      ).thenAnswer((_) async => Right(response));

      // act
      final result = await usecase(requestId: testRequestId);

      // assert
      expect(result, const Right(response));
      verify(mockFriendshipRepository.acceptRequest(requestId: testRequestId));
      verifyNoMoreInteractions(mockFriendshipRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(
        mockFriendshipRepository.acceptRequest(
          requestId: anyNamed('requestId'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(requestId: testRequestId);

      // assert
      expect(result, const Left(failure));
      verify(mockFriendshipRepository.acceptRequest(requestId: testRequestId));
      verifyNoMoreInteractions(mockFriendshipRepository);
    });

    test('should return not found failure for invalid request ID', () async {
      // arrange
      const failure = NotFoundFailure(message: 'Friend request not found');
      when(
        mockFriendshipRepository.acceptRequest(
          requestId: anyNamed('requestId'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(requestId: 'invalid123');

      // assert
      expect(result, const Left(failure));
      verify(mockFriendshipRepository.acceptRequest(requestId: 'invalid123'));
      verifyNoMoreInteractions(mockFriendshipRepository);
    });
  });
}
