import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';
import 'package:social_app/features/reaction/domain/usecases/get_user_reaction_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetUserReactionUsecase usecase;
  late MockReactionRepository mockReactionRepository;

  setUp(() {
    mockReactionRepository = MockReactionRepository();
    usecase = GetUserReactionUsecase(repository: mockReactionRepository);
  });

  const testTargetType = ReactionTargetType.post;
  const testTargetId = 'post123';

  group('GetUserReactionUsecase', () {
    test('should get user reaction from repository', () async {
      // arrange
      when(mockReactionRepository.getUserReaction(
        targetType: anyNamed('targetType'),
        targetId: anyNamed('targetId'),
      )).thenAnswer((_) async => Right(TestData.testReaction));

      // act
      final result = await usecase(
        targetType: testTargetType,
        targetId: testTargetId,
      );

      // assert
      expect(result, Right(TestData.testReaction));
      verify(mockReactionRepository.getUserReaction(
        targetType: testTargetType,
        targetId: testTargetId,
      ));
      verifyNoMoreInteractions(mockReactionRepository);
    });

    test('should return null when user has not reacted', () async {
      // arrange
      when(mockReactionRepository.getUserReaction(
        targetType: anyNamed('targetType'),
        targetId: anyNamed('targetId'),
      )).thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(
        targetType: testTargetType,
        targetId: testTargetId,
      );

      // assert
      expect(result, const Right(null));
      verify(mockReactionRepository.getUserReaction(
        targetType: testTargetType,
        targetId: testTargetId,
      ));
      verifyNoMoreInteractions(mockReactionRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(mockReactionRepository.getUserReaction(
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
      verify(mockReactionRepository.getUserReaction(
        targetType: testTargetType,
        targetId: testTargetId,
      ));
      verifyNoMoreInteractions(mockReactionRepository);
    });

    test('should handle comment target type', () async {
      // arrange
      const commentTargetType = ReactionTargetType.comment;
      const commentTargetId = 'comment123';
      when(mockReactionRepository.getUserReaction(
        targetType: anyNamed('targetType'),
        targetId: anyNamed('targetId'),
      )).thenAnswer((_) async => Right(TestData.testReaction));

      // act
      final result = await usecase(
        targetType: commentTargetType,
        targetId: commentTargetId,
      );

      // assert
      expect(result, Right(TestData.testReaction));
      verify(mockReactionRepository.getUserReaction(
        targetType: commentTargetType,
        targetId: commentTargetId,
      ));
      verifyNoMoreInteractions(mockReactionRepository);
    });
  });
}
