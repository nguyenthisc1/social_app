import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/post/domain/entities/post_entity.dart';
import 'package:social_app/features/post/domain/usecases/get_home_post_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetHomePostUsecase usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetHomePostUsecase(repository: mockPostRepository);
  });

  const testPostId = 'post123';

  group('GetHomePostUsecase', () {
    test('should get home posts from repository', () async {
      // arrange
      when(mockPostRepository.getHomePost())
          .thenAnswer((_) async => Right(TestData.testPostList));

      // act
      final result = await usecase(testPostId);

      // assert
      expect(result, Right(TestData.testPostList));
      verify(mockPostRepository.getHomePost());
      verifyNoMoreInteractions(mockPostRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(mockPostRepository.getHomePost())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(testPostId);

      // assert
      expect(result, const Left(failure));
      verify(mockPostRepository.getHomePost());
      verifyNoMoreInteractions(mockPostRepository);
    });

    test('should return empty list when no posts available', () async {
      // arrange
      when(mockPostRepository.getHomePost())
          .thenAnswer((_) async => Right(<PostEntity>[]));

      // act
      final result = await usecase(testPostId);

      // assert
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (posts) => expect(posts, isEmpty),
      );
      verify(mockPostRepository.getHomePost());
      verifyNoMoreInteractions(mockPostRepository);
    });
  });
}
