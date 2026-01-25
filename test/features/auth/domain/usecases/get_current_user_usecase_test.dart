import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/auth/domain/usecases/get_current_user_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetCurrentUserUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetCurrentUserUseCase(mockAuthRepository);
  });

  group('GetCurrentUserUseCase', () {
    test('should get current user from repository', () async {
      // arrange
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => Right(TestData.testUser));

      // act
      final result = await usecase();

      // assert
      expect(result, Right(TestData.testUser));
      verify(mockAuthRepository.getCurrentUser());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return failure when user is not authenticated', () async {
      // arrange
      const failure = CacheFailure(message: 'No user found in cache');
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase();

      // assert
      expect(result, const Left(failure));
      verify(mockAuthRepository.getCurrentUser());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return failure when network error occurs', () async {
      // arrange
      const failure = NetworkFailure();
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase();

      // assert
      expect(result, const Left(failure));
      verify(mockAuthRepository.getCurrentUser());
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
