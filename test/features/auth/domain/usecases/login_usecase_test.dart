import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/auth/domain/usecases/login_usecase.dart';

import '../../../../fixtures/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUseCase(mockAuthRepository);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'Test@1234';

  group('LoginUseCase', () {
    test('should login user with valid credentials', () async {
      // arrange
      when(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => Right(TestData.testUser));

      // act
      final result = await usecase(
        email: testEmail,
        password: testPassword,
      );

      // assert
      expect(result, Right(TestData.testUser));
      verify(mockAuthRepository.login(
        email: testEmail,
        password: testPassword,
      ));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return failure when credentials are invalid', () async {
      // arrange
      const failure = ServerFailure(message: 'Invalid credentials');
      when(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(
        email: testEmail,
        password: 'wrongpassword',
      );

      // assert
      expect(result, const Left(failure));
      verify(mockAuthRepository.login(
        email: testEmail,
        password: 'wrongpassword',
      ));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return failure when network error occurs', () async {
      // arrange
      const failure = NetworkFailure();
      when(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(
        email: testEmail,
        password: testPassword,
      );

      // assert
      expect(result, const Left(failure));
      verify(mockAuthRepository.login(
        email: testEmail,
        password: testPassword,
      ));
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
