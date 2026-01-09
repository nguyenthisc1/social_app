import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/auth/domain/entities/user.dart';
import 'package:social_app/features/auth/domain/usecases/get_current_user_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetCurrentUserUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetCurrentUserUseCase(mockAuthRepository);
  });

  final tUser = User(
    id: 'user123',
    email: 'test@example.com',
    username: 'testuser',
    createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
    updatedAt: DateTime.now(),
  );

  test('should return current user when authenticated', () async {
    // arrange
    when(
      mockAuthRepository.getCurrentUser(),
    ).thenAnswer((_) async => Right(tUser));

    // act
    final result = await usecase();

    // assert
    expect(result, Right(tUser));
    verify(mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return UnauthorizedFailure when not authenticated', () async {
    // arrange
    when(mockAuthRepository.getCurrentUser()).thenAnswer(
      (_) async =>
          const Left(UnauthorizedFailure(message: 'No valid authentication')),
    );

    // act
    final result = await usecase();

    // assert
    expect(
      result,
      const Left(UnauthorizedFailure(message: 'No valid authentication')),
    );
    verify(mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
