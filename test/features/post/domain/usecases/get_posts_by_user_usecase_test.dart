import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/post/domain/entities/post_entity.dart';
import 'package:social_app/features/post/domain/usecases/get_posts_by_user_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPostsByUserUsecase usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetPostsByUserUsecase(repository: mockPostRepository);
  });

  const testUserId = 'user123';

  group('GetPostsByUserUsecase', () {
    test('should get posts by user from repository', () async {
      // arrange
      when(mockPostRepository.getPostsByUser(any))
          .thenAnswer((_) async => Right(TestData.testPostList));

      // act
      final result = await usecase(testUserId);

      // assert
      expect(result, Right(TestData.testPostList));
      verify(mockPostRepository.getPostsByUser(testUserId));
      verifyNoMoreInteractions(mockPostRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(mockPostRepository.getPostsByUser(any))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(testUserId);

      // assert
      expect(result, const Left(failure));
      verify(mockPostRepository.getPostsByUser(testUserId));
      verifyNoMoreInteractions(mockPostRepository);
    });

    test('should return empty list when user has no posts', () async {
      // arrange
      when(mockPostRepository.getPostsByUser(any))
          .thenAnswer((_) async => Right(<PostEntity>[]));

      // act
      final result = await usecase(testUserId);

      // assert
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (posts) => expect(posts, isEmpty),
      );
      verify(mockPostRepository.getPostsByUser(testUserId));
      verifyNoMoreInteractions(mockPostRepository);
    });
  });
}
