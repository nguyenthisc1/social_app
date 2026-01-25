import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/core/entities/pagination_param.dart';
import 'package:social_app/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app/features/comment/domain/usecases/get_comments_by_post_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetCommentsByPostUsecase usecase;
  late MockCommentRepository mockCommentRepository;

  setUp(() {
    mockCommentRepository = MockCommentRepository();
    usecase = GetCommentsByPostUsecase(repository: mockCommentRepository);
  });

  const testPostId = 'post123';
  const testParams = PaginationParams(limit: 10);

  group('GetCommentsByPostUsecase', () {
    test('should get comments by post from repository', () async {
      // arrange
      when(mockCommentRepository.getCommentsByPost(
        postId: anyNamed('postId'),
        query: anyNamed('query'),
      )).thenAnswer((_) async => Right(TestData.testCommentList));

      // act
      final result = await usecase(postId: testPostId, query: testParams);

      // assert
      expect(result, Right(TestData.testCommentList));
      verify(mockCommentRepository.getCommentsByPost(
        postId: testPostId,
        query: testParams,
      ));
      verifyNoMoreInteractions(mockCommentRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(mockCommentRepository.getCommentsByPost(
        postId: anyNamed('postId'),
        query: anyNamed('query'),
      )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(postId: testPostId, query: testParams);

      // assert
      expect(result, const Left(failure));
      verify(mockCommentRepository.getCommentsByPost(
        postId: testPostId,
        query: testParams,
      ));
      verifyNoMoreInteractions(mockCommentRepository);
    });

    test('should return empty list when post has no comments', () async {
      // arrange
      when(mockCommentRepository.getCommentsByPost(
        postId: anyNamed('postId'),
        query: anyNamed('query'),
      )).thenAnswer((_) async => Right(<CommentEntity>[]));

      // act
      final result = await usecase(postId: testPostId, query: testParams);

      // assert
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (comments) => expect(comments, isEmpty),
      );
      verify(mockCommentRepository.getCommentsByPost(
        postId: testPostId,
        query: testParams,
      ));
      verifyNoMoreInteractions(mockCommentRepository);
    });
  });
}
