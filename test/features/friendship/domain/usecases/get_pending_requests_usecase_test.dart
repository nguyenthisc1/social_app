import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/usecases/get_pending_requests_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPendingRequestsUsecase usecase;
  late MockFriendshipRepository mockFriendshipRepository;

  setUp(() {
    mockFriendshipRepository = MockFriendshipRepository();
    usecase = GetPendingRequestsUsecase(repository: mockFriendshipRepository);
  });

  group('GetPendingRequestsUsecase', () {
    test('should get pending requests from repository', () async {
      // arrange
      final testRequests = [TestData.testFriendRequest];
      when(mockFriendshipRepository.getPendingRequests())
          .thenAnswer((_) async => Right(testRequests));

      // act
      final result = await usecase();

      // assert
      expect(result, Right(testRequests));
      verify(mockFriendshipRepository.getPendingRequests());
      verifyNoMoreInteractions(mockFriendshipRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(mockFriendshipRepository.getPendingRequests())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase();

      // assert
      expect(result, const Left(failure));
      verify(mockFriendshipRepository.getPendingRequests());
      verifyNoMoreInteractions(mockFriendshipRepository);
    });

    test('should return empty list when no pending requests', () async {
      // arrange
      when(mockFriendshipRepository.getPendingRequests())
          .thenAnswer((_) async => Right(<FriendRequestEntity>[]));

      // act
      final result = await usecase();

      // assert
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (requests) => expect(requests, isEmpty),
      );
      verify(mockFriendshipRepository.getPendingRequests());
      verifyNoMoreInteractions(mockFriendshipRepository);
    });
  });
}
