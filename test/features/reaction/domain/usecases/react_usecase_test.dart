import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';
import 'package:social_app/features/reaction/domain/usecases/react_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late ReactUsecase usecase;
  late MockReactionRepository mockReactionRepository;

  setUp(() {
    mockReactionRepository = MockReactionRepository();
    usecase = ReactUsecase(repository: mockReactionRepository);
  });

  const testTargetType = ReactionTargetType.post;
  const testTargetId = 'post123';
  const testReactionType = ReactionType.like;

  group('ReactUsecase', () {
    test('should create reaction from repository', () async {
      // arrange
      when(mockReactionRepository.react(
        targetType: anyNamed('targetType'),
        targetId: anyNamed('targetId'),
        type: anyNamed('type'),
      )).thenAnswer((_) async => Right(TestData.testReactionResponse));

      // act
      final result = await usecase(
        targetType: testTargetType,
        targetId: testTargetId,
        type: testReactionType,
      );

      // assert
      expect(result, Right(TestData.testReactionResponse));
      verify(mockReactionRepository.react(
        targetType: testTargetType,
        targetId: testTargetId,
        type: testReactionType,
      ));
      verifyNoMoreInteractions(mockReactionRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure(message: 'Server error');
      when(mockReactionRepository.react(
        targetType: anyNamed('targetType'),
        targetId: anyNamed('targetId'),
        type: anyNamed('type'),
      )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(
        targetType: testTargetType,
        targetId: testTargetId,
        type: testReactionType,
      );

      // assert
      expect(result, const Left(failure));
      verify(mockReactionRepository.react(
        targetType: testTargetType,
        targetId: testTargetId,
        type: testReactionType,
      ));
      verifyNoMoreInteractions(mockReactionRepository);
    });

    test('should handle different reaction types', () async {
      // arrange
      const differentType = ReactionType.love;
      when(mockReactionRepository.react(
        targetType: anyNamed('targetType'),
        targetId: anyNamed('targetId'),
        type: anyNamed('type'),
      )).thenAnswer((_) async => Right(TestData.testReactionResponse));

      // act
      final result = await usecase(
        targetType: testTargetType,
        targetId: testTargetId,
        type: differentType,
      );

      // assert
      expect(result, Right(TestData.testReactionResponse));
      verify(mockReactionRepository.react(
        targetType: testTargetType,
        targetId: testTargetId,
        type: differentType,
      ));
      verifyNoMoreInteractions(mockReactionRepository);
    });

    test('should handle comment target type', () async {
      // arrange
      const commentTargetType = ReactionTargetType.comment;
      const commentTargetId = 'comment123';
      when(mockReactionRepository.react(
        targetType: anyNamed('targetType'),
        targetId: anyNamed('targetId'),
        type: anyNamed('type'),
      )).thenAnswer((_) async => Right(TestData.testReactionResponse));

      // act
      final result = await usecase(
        targetType: commentTargetType,
        targetId: commentTargetId,
        type: testReactionType,
      );

      // assert
      expect(result, Right(TestData.testReactionResponse));
      verify(mockReactionRepository.react(
        targetType: commentTargetType,
        targetId: commentTargetId,
        type: testReactionType,
      ));
      verifyNoMoreInteractions(mockReactionRepository);
    });
  });
}
