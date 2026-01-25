import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/core/entities/pagination_param.dart';
import 'package:social_app/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app/features/comment/domain/usecases/get_replies_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetCommentsByPostUsecase usecase;
  late MockCommentRepository mockCommentRepository;

  setUp(() {
    mockCommentRepository = MockCommentRepository();
    usecase = GetCommentsByPostUsecase(repository: mockCommentRepository);
  });

  const testCommentId = 'comment123';
  const testParams = PaginationParams(limit: 10);

  group('GetRepliesUsecase', () {
    test('should get replies from repository', () async {
      // arrange
      final testReplies = [TestData.testReply];
      when(mockCommentRepository.getReplies(
        commentId: anyNamed('commentId'),
        query: anyNamed('query'),
      )).thenAnswer((_) async => Right(testReplies));

      // act
      final result = await usecase(commentId: testCommentId, query: testParams);

      // assert
      expect(result, Right(testReplies));
      verify(mockCommentRepository.getReplies(
        commentId: testCommentId,
        query: testParams,
      ));
      verifyNoMoreInteractions(mockCommentRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(mockCommentRepository.getReplies(
        commentId: anyNamed('commentId'),
        query: anyNamed('query'),
      )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(commentId: testCommentId, query: testParams);

      // assert
      expect(result, const Left(failure));
      verify(mockCommentRepository.getReplies(
        commentId: testCommentId,
        query: testParams,
      ));
      verifyNoMoreInteractions(mockCommentRepository);
    });

    test('should return empty list when comment has no replies', () async {
      // arrange
      when(mockCommentRepository.getReplies(
        commentId: anyNamed('commentId'),
        query: anyNamed('query'),
      )).thenAnswer((_) async => Right(<CommentEntity>[]));

      // act
      final result = await usecase(commentId: testCommentId, query: testParams);

      // assert
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (replies) => expect(replies, isEmpty),
      );
      verify(mockCommentRepository.getReplies(
        commentId: testCommentId,
        query: testParams,
      ));
      verifyNoMoreInteractions(mockCommentRepository);
    });
  });
}
