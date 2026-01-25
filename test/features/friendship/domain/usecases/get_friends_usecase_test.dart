import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/usecases/get_friends_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetFriendsUsecase usecase;
  late MockFriendshipRepository mockFriendshipRepository;

  setUp(() {
    mockFriendshipRepository = MockFriendshipRepository();
    usecase = GetFriendsUsecase(repository: mockFriendshipRepository);
  });

  group('GetFriendsUsecase', () {
    test('should get friends list from repository', () async {
      // arrange
      when(mockFriendshipRepository.getFriends())
          .thenAnswer((_) async => Right(TestData.testFriendsList));

      // act
      final result = await usecase();

      // assert
      expect(result, Right(TestData.testFriendsList));
      verify(mockFriendshipRepository.getFriends());
      verifyNoMoreInteractions(mockFriendshipRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(mockFriendshipRepository.getFriends())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase();

      // assert
      expect(result, const Left(failure));
      verify(mockFriendshipRepository.getFriends());
      verifyNoMoreInteractions(mockFriendshipRepository);
    });

    test('should return empty list when user has no friends', () async {
      // arrange
      when(mockFriendshipRepository.getFriends())
          .thenAnswer((_) async => Right(<FriendEntity>[]));

      // act
      final result = await usecase();

      // assert
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (friends) => expect(friends, isEmpty),
      );
      verify(mockFriendshipRepository.getFriends());
      verifyNoMoreInteractions(mockFriendshipRepository);
    });
  });
}
