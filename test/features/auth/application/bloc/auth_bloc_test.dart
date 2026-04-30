import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/core/domain/usecases/usecases.dart';
import 'package:social_app/features/auth/application/bloc/auth_bloc.dart';
import 'package:social_app/features/auth/domain/auth_params.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../fixtures/auth_fixtures.dart';

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;

  late AuthBloc bloc;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();

    bloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  group('initial', () {
    test('Case 1: register bloc, no event => state is AuthInitial', () {
      expect(bloc.state, const AuthInitial());
    });
  });

  group('AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'Case 1: auth status = true, get current user success => emits [AuthEventState, AuthLoading, AuthAuthenticated]',
      build: () {
        when(
          mockCheckAuthStatusUseCase.call(NoParams()),
        ).thenAnswer((_) async => true);
        when(
          mockGetCurrentUserUseCase.call(NoParams()),
        ).thenAnswer((_) async => fakeUserEntity);
        return bloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [
        isA<AuthEventState>(),
        isA<AuthLoading>(),
        AuthAuthenticated(fakeUserEntity),
      ],
      verify: (_) {
        verify(mockCheckAuthStatusUseCase.call(NoParams())).called(1);
        verify(mockGetCurrentUserUseCase.call(NoParams())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'Case 2: auth status = false => emits [AuthEventState, AuthLoading, AuthUnauthenticated]',
      build: () {
        when(
          mockCheckAuthStatusUseCase.call(NoParams()),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [
        isA<AuthEventState>(),
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
      verify: (_) {
        verify(mockCheckAuthStatusUseCase.call(NoParams())).called(1);
        verifyNever(mockGetCurrentUserUseCase.call(NoParams()));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'Case 3: auth status = true, get current user fail => emits [AuthEventState, AuthLoading, AuthUnauthenticated]',
      build: () {
        when(
          mockCheckAuthStatusUseCase.call(NoParams()),
        ).thenAnswer((_) async => true);
        when(
          mockGetCurrentUserUseCase.call(NoParams()),
        ).thenThrow(ServerException());
        return bloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [
        isA<AuthEventState>(),
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
    );
  });

  group('AuthLoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'Case 1: login success => emits [AuthEventState, AuthLoading, AuthAuthenticated]',
      build: () {
        when(
          mockLoginUseCase.call(
            const LoginParams(email: 'test@mail.com', password: '123456'),
          ),
        ).thenAnswer((_) async => fakeUserEntity);
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(email: 'test@mail.com', password: '123456'),
      ),
      expect: () => [
        isA<AuthEventState>(),
        isA<AuthLoading>(),
        AuthAuthenticated(fakeUserEntity),
      ],
      verify: (_) {
        verify(
          mockLoginUseCase.call(
            const LoginParams(email: 'test@mail.com', password: '123456'),
          ),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'Case 2: login fail with ExceptionBase => emits [AuthEventState, AuthLoading, AuthError(userMessage)]',
      build: () {
        when(
          mockLoginUseCase.call(
            const LoginParams(
              email: 'test@mail.com',
              password: 'wrong-password',
            ),
          ),
        ).thenThrow(
          UnauthorizedException(
            userMessage: 'Invalid credentials.',
            debugMessage: 'Login failed in test.',
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(
          email: 'test@mail.com',
          password: 'wrong-password',
        ),
      ),
      expect: () => [
        isA<AuthEventState>(),
        isA<AuthLoading>(),
        const AuthError('Invalid credentials.'),
      ],
    );
  });

  group('AuthRegisterRequested', () {
    blocTest<AuthBloc, AuthState>(
      'Case 1: register success => authenticated',
      build: () {
        when(
          mockRegisterUseCase.call(
            const RegisterParams(
              email: 'test@mail.com',
              username: 'thinguyen',
              password: '123456',
            ),
          ),
        ).thenAnswer((_) async => fakeUserEntity);
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthRegisterRequested(
          email: 'test@mail.com',
          username: 'thinguyen',
          password: '123456',
        ),
      ),
      expect: () => [
        isA<AuthEventState>(),
        isA<AuthLoading>(),
        AuthAuthenticated(fakeUserEntity),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'Case 2: register fail => auth error',
      build: () {
        when(
          mockRegisterUseCase.call(
            const RegisterParams(
              email: 'test@mail.com',
              username: 'thinguyen',
              password: '123456',
            ),
          ),
        ).thenThrow(
          ConflictException(
            userMessage: 'Account already exists.',
            debugMessage: 'Register conflict in test.',
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthRegisterRequested(
          email: 'test@mail.com',
          username: 'thinguyen',
          password: '123456',
        ),
      ),
      expect: () => [
        isA<AuthEventState>(),
        isA<AuthLoading>(),
        const AuthError('Account already exists.'),
      ],
    );
  });

  group('AuthLogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'Case 1: logout success => unauthenticated',
      build: () {
        when(mockLogoutUseCase.call(NoParams())).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [
        isA<AuthEventState>(),
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
      verify: (_) {
        verify(mockLogoutUseCase.call(NoParams())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'Case 2: logout fail => auth error',
      build: () {
        when(mockLogoutUseCase.call(NoParams())).thenThrow(
          CacheException(
            userMessage: 'Unable to clear your session.',
            debugMessage: 'Logout failed in test.',
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [
        isA<AuthEventState>(),
        isA<AuthLoading>(),
        const AuthError('Unable to clear your session.'),
      ],
    );
  });

  group('AuthGetCurrentUserRequested', () {
    blocTest<AuthBloc, AuthState>(
      'Case 1: get current user success => authenticated',
      build: () {
        when(
          mockGetCurrentUserUseCase.call(NoParams()),
        ).thenAnswer((_) async => fakeUserEntity);
        return bloc;
      },
      act: (bloc) => bloc.add(AuthGetCurrentUserRequested()),
      expect: () => [
        isA<AuthEventState>(),
        isA<AuthLoading>(),
        AuthAuthenticated(fakeUserEntity),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'Case 2: get current user fail => auth error',
      build: () {
        when(mockGetCurrentUserUseCase.call(NoParams())).thenThrow(
          UnauthorizedException(
            userMessage: 'Unauthorized.',
            debugMessage: 'Get current user failed in test.',
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(AuthGetCurrentUserRequested()),
      expect: () => [
        isA<AuthEventState>(),
        isA<AuthLoading>(),
        const AuthError('Unauthorized.'),
      ],
    );
  });
}
