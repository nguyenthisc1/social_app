import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/auth/domain/entities/user.dart';
import 'package:social_app/features/auth/domain/usecases/register_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late RegisterUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = RegisterUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tUsername = 'testuser';
  const tPassword = 'password123';
  final tUser = User(
    id: 'user123',
    email: tEmail,
    username: tUsername,
    createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
    updatedAt: DateTime.now(),
  );

  test('should return User when registration is successful', () async {
    // arrange
    when(
      mockAuthRepository.register(
        email: anyNamed('email'),
        username: anyNamed('username'),
        password: anyNamed('password'),
      ),
    ).thenAnswer((_) async => Right(tUser));

    // act
    final result = await usecase(
      email: tEmail,
      username: tUsername,
      password: tPassword,
    );

    // assert
    expect(result, Right(tUser));
    verify(
      mockAuthRepository.register(
        email: tEmail,
        username: tUsername,
        password: tPassword,
      ),
    );
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return ValidationFailure when email is invalid', () async {
    // arrange
    when(
      mockAuthRepository.register(
        email: anyNamed('email'),
        username: anyNamed('username'),
        password: anyNamed('password'),
      ),
    ).thenAnswer(
      (_) async => const Left(
        ValidationFailure(
          message: 'Invalid email format',
          errors: {
            'email': ['Invalid email format'],
          },
        ),
      ),
    );

    // act
    final result = await usecase(
      email: 'invalid-email',
      username: tUsername,
      password: tPassword,
    );

    // assert
    expect(result.isLeft(), true);
    result.fold((failure) {
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'Invalid email format');
    }, (_) => fail('Should return failure'));
  });
}
