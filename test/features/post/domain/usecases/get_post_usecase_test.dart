import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/post/domain/usecases/get_post_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPostUsecase usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetPostUsecase(repository: mockPostRepository);
  });

  const testPostId = 'post123';

  group('GetPostUsecase', () {
    test('should get post from repository', () async {
      // arrange
      when(mockPostRepository.getPost(any))
          .thenAnswer((_) async => Right(TestData.testPost));

      // act
      final result = await usecase(testPostId);

      // assert
      expect(result, Right(TestData.testPost));
      verify(mockPostRepository.getPost(testPostId));
      verifyNoMoreInteractions(mockPostRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(mockPostRepository.getPost(any))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(testPostId);

      // assert
      expect(result, const Left(failure));
      verify(mockPostRepository.getPost(testPostId));
      verifyNoMoreInteractions(mockPostRepository);
    });
  });
}
