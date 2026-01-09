import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/auth/domain/entities/user.dart';
import 'package:social_app/features/auth/domain/usecases/login_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tUser = User(
    id: 'user123',
    email: tEmail,
    username: 'testuser',
    createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
    updatedAt: DateTime.now(),
  );

  test('should return User when login is successful', () async {
    // arrange
    when(
      mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer((_) async => Right(tUser));

    // act
    final result = await usecase(email: tEmail, password: tPassword);

    // assert
    expect(result, Right(tUser));
    verify(mockAuthRepository.login(email: tEmail, password: tPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should forward repository failures', () async {
    // arrange
    when(
      mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer(
      (_) async => Left(ServerFailure(message: 'Invalid credentials')),
    );

    // act
    final result = await usecase(email: tEmail, password: tPassword);

    // assert
    expect(result, const Left(ServerFailure(message: 'Invalid credentials')));
    verify(mockAuthRepository.login(email: tEmail, password: tPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
