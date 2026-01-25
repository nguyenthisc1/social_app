import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/usecases/check_friendship_status_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late CheckFriendshipStatusUsecase usecase;
  late MockFriendshipRepository mockFriendshipRepository;

  setUp(() {
    mockFriendshipRepository = MockFriendshipRepository();
    usecase = CheckFriendshipStatusUsecase(repository: mockFriendshipRepository);
  });

  const testUserAId = 'user123';
  const testUserBId = 'user456';

  group('CheckFriendshipStatusUsecase', () {
    test('should check if users are friends from repository', () async {
      // arrange
      when(mockFriendshipRepository.isFriend(
        userAId: anyNamed('userAId'),
        userBId: anyNamed('userBId'),
      )).thenAnswer((_) async => Right(TestData.testFriendshipStatus));

      // act
      final result = await usecase(
        userAId: testUserAId,
        userBId: testUserBId,
      );

      // assert
      expect(result, Right(TestData.testFriendshipStatus));
      verify(mockFriendshipRepository.isFriend(
        userAId: testUserAId,
        userBId: testUserBId,
      ));
      verifyNoMoreInteractions(mockFriendshipRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(mockFriendshipRepository.isFriend(
        userAId: anyNamed('userAId'),
        userBId: anyNamed('userBId'),
      )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(
        userAId: testUserAId,
        userBId: testUserBId,
      );

      // assert
      expect(result, const Left(failure));
      verify(mockFriendshipRepository.isFriend(
        userAId: testUserAId,
        userBId: testUserBId,
      ));
      verifyNoMoreInteractions(mockFriendshipRepository);
    });

    test('should return false when users are not friends', () async {
      // arrange
      const notFriendsStatus = FriendshipStatusEntity(
        isFriend: false,
        message: 'Users are not friends',
      );
      when(mockFriendshipRepository.isFriend(
        userAId: anyNamed('userAId'),
        userBId: anyNamed('userBId'),
      )).thenAnswer((_) async => Right(notFriendsStatus));

      // act
      final result = await usecase(
        userAId: testUserAId,
        userBId: testUserBId,
      );

      // assert
      expect(result, Right(notFriendsStatus));
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (status) {
          expect(status.isFriend, false);
          expect(status.message, 'Users are not friends');
        },
      );
      verify(mockFriendshipRepository.isFriend(
        userAId: testUserAId,
        userBId: testUserBId,
      ));
      verifyNoMoreInteractions(mockFriendshipRepository);
    });
  });
}
