import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/friendship/domain/usecases/send_friend_request_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SendFriendRequestUsecase usecase;
  late MockFriendshipRepository mockFriendshipRepository;

  setUp(() {
    mockFriendshipRepository = MockFriendshipRepository();
    usecase = SendFriendRequestUsecase(repository: mockFriendshipRepository);
  });

  const testToUserId = 'user456';

  group('SendFriendRequestUsecase', () {
    test('should send friend request from repository', () async {
      // arrange
      when(mockFriendshipRepository.sendRequest(
        toUserId: anyNamed('toUserId'),
      )).thenAnswer((_) async => Right(TestData.testFriendshipResponse));

      // act
      final result = await usecase(toUserId: testToUserId);

      // assert
      expect(result, Right(TestData.testFriendshipResponse));
      verify(mockFriendshipRepository.sendRequest(toUserId: testToUserId));
      verifyNoMoreInteractions(mockFriendshipRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(mockFriendshipRepository.sendRequest(
        toUserId: anyNamed('toUserId'),
      )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(toUserId: testToUserId);

      // assert
      expect(result, const Left(failure));
      verify(mockFriendshipRepository.sendRequest(toUserId: testToUserId));
      verifyNoMoreInteractions(mockFriendshipRepository);
    });

    test('should return validation failure for invalid user ID', () async {
      // arrange
      const failure = ValidationFailure(message: 'Invalid user ID');
      when(mockFriendshipRepository.sendRequest(
        toUserId: anyNamed('toUserId'),
      )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(toUserId: 'invalid');

      // assert
      expect(result, const Left(failure));
      verify(mockFriendshipRepository.sendRequest(toUserId: 'invalid'));
      verifyNoMoreInteractions(mockFriendshipRepository);
    });
  });
}
