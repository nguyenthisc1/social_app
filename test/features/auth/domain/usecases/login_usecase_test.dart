import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/features/auth/domain/auth_params.dart';
import 'package:social_app/features/auth/domain/usecases/login_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../fixtures/auth_fixtures.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase Input Validation & Repository Delegation', () {
    test(
      'Case 1: Given valid email and password, when calling LoginUseCase, then repository.login is called and returns UserEntity',
      () async {
        // Given
        const params = LoginParams(email: 'test@mail.com', password: '123456');
        when(
          mockAuthRepository.login(
            email: params.email,
            password: params.password,
          ),
        ).thenAnswer((_) async => fakeUserEntity);

        // When
        final result = await loginUseCase(params);

        // Then
        expect(result, fakeUserEntity);
        verify(
          mockAuthRepository.login(
            email: params.email,
            password: params.password,
          ),
        ).called(1);
      },
    );

    test(
      'Case 2: Given invalid email format, when calling LoginUseCase, then throw ArgumentInvalidException and repository.login is not called',
      () async {
        // Given
        const params = LoginParams(email: 'invalid-email', password: '123456');

        // When & Then
        expect(
          () => loginUseCase(params),
          throwsA(isA<ArgumentInvalidException>()),
        );
        verifyNever(
          mockAuthRepository.login(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        );
      },
    );

    test(
      'Case 3: Given empty password, when calling LoginUseCase, then throw ArgumentNotProvidedException and repository.login is not called',
      () async {
        // Given
        const params = LoginParams(email: 'test@mail.com', password: '');

        // When & Then
        expect(
          () => loginUseCase(params),
          throwsA(isA<ArgumentNotProvidedException>()),
        );
        verifyNever(
          mockAuthRepository.login(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        );
      },
    );
  });
}
