import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/features/auth/domain/auth_params.dart';
import 'package:social_app/features/auth/domain/usecases/register_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../fixtures/auth_fixtures.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late RegisterUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockAuthRepository);
  });

  group('RegisterUseCase validation', () {
    test(
      'Case 1: valid email, valid username, password >= 6 => calls repository.register, returns UserEntity',
      () async {
        // Given
        const params = RegisterParams(
          email: 'valid.email@example.com',
          username: 'validuser',
          password: '123456',
        );
        when(
          mockAuthRepository.register(
            email: params.email,
            username: params.username,
            password: params.password,
          ),
        ).thenAnswer((_) async => fakeUserEntity);

        // When
        final result = await useCase(params);

        // Then
        expect(result, fakeUserEntity);
        verify(
          mockAuthRepository.register(
            email: params.email,
            username: params.username,
            password: params.password,
          ),
        ).called(1);
      },
    );

    test(
      'Case 2: invalid email => throws ArgumentInvalidException, repository not called',
      () async {
        // Given
        const params = RegisterParams(
          email: 'invalid-email',
          username: 'validuser',
          password: '123456',
        );
        // When & Then
        expect(() => useCase(params), throwsA(isA<ArgumentInvalidException>()));
        verifyNever(
          mockAuthRepository.register(
            email: anyNamed('email'),
            username: anyNamed('username'),
            password: anyNamed('password'),
          ),
        );
      },
    );

    test(
      'Case 3: empty username => throws ArgumentNotProvidedException, repository not called',
      () async {
        // Given
        const params = RegisterParams(
          email: 'valid.email@example.com',
          username: '',
          password: '123456',
        );
        // When & Then
        expect(
          () => useCase(params),
          throwsA(isA<ArgumentNotProvidedException>()),
        );
        verifyNever(
          mockAuthRepository.register(
            email: anyNamed('email'),
            username: anyNamed('username'),
            password: anyNamed('password'),
          ),
        );
      },
    );

    test(
      'Case 4: password < 6 => throws ArgumentInvalidException, repository not called',
      () async {
        // Given
        const params = RegisterParams(
          email: 'valid.email@example.com',
          username: 'validuser',
          password: '123',
        );
        // When & Then
        expect(() => useCase(params), throwsA(isA<ArgumentInvalidException>()));
        verifyNever(
          mockAuthRepository.register(
            email: anyNamed('email'),
            username: anyNamed('username'),
            password: anyNamed('password'),
          ),
        );
      },
    );
  });
}
