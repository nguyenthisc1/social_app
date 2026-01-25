import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_entity.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';
import 'package:social_app/features/reaction/domain/usecases/get_reaction_summary_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetReactionSummaryUsecase usecase;
  late MockReactionRepository mockReactionRepository;

  setUp(() {
    mockReactionRepository = MockReactionRepository();
    usecase = GetReactionSummaryUsecase(repository: mockReactionRepository);
  });

  const testTargetType = ReactionTargetType.post;
  const testTargetId = 'post123';

  group('GetReactionSummaryUsecase', () {
    test('should get reaction summary from repository', () async {
      // arrange
      when(mockReactionRepository.getReactionSummary(
        targetType: anyNamed('targetType'),
        targetId: anyNamed('targetId'),
      )).thenAnswer((_) async => Right(TestData.testReactionSummary));

      // act
      final result = await usecase(
        targetType: testTargetType,
        targetId: testTargetId,
      );

      // assert
      expect(result, Right(TestData.testReactionSummary));
      verify(mockReactionRepository.getReactionSummary(
        targetType: testTargetType,
        targetId: testTargetId,
      ));
      verifyNoMoreInteractions(mockReactionRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(mockReactionRepository.getReactionSummary(
        targetType: anyNamed('targetType'),
        targetId: anyNamed('targetId'),
      )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(
        targetType: testTargetType,
        targetId: testTargetId,
      );

      // assert
      expect(result, const Left(failure));
      verify(mockReactionRepository.getReactionSummary(
        targetType: testTargetType,
        targetId: testTargetId,
      ));
      verifyNoMoreInteractions(mockReactionRepository);
    });

    test('should return empty list when no reactions', () async {
      // arrange
      when(mockReactionRepository.getReactionSummary(
        targetType: anyNamed('targetType'),
        targetId: anyNamed('targetId'),
      )).thenAnswer((_) async => Right(<ReactionSummaryEntity>[]));

      // act
      final result = await usecase(
        targetType: testTargetType,
        targetId: testTargetId,
      );

      // assert
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (summary) => expect(summary, isEmpty),
      );
      verify(mockReactionRepository.getReactionSummary(
        targetType: testTargetType,
        targetId: testTargetId,
      ));
      verifyNoMoreInteractions(mockReactionRepository);
    });

    test('should handle comment target type', () async {
      // arrange
      const commentTargetType = ReactionTargetType.comment;
      const commentTargetId = 'comment123';
      when(mockReactionRepository.getReactionSummary(
        targetType: anyNamed('targetType'),
        targetId: anyNamed('targetId'),
      )).thenAnswer((_) async => Right(TestData.testReactionSummary));

      // act
      final result = await usecase(
        targetType: commentTargetType,
        targetId: commentTargetId,
      );

      // assert
      expect(result, Right(TestData.testReactionSummary));
      verify(mockReactionRepository.getReactionSummary(
        targetType: commentTargetType,
        targetId: commentTargetId,
      ));
      verifyNoMoreInteractions(mockReactionRepository);
    });
  });
}
