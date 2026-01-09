import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:social_app/core/errors/failures.dart';
import 'package:social_app/features/auth/domain/entities/user.dart';
import 'package:social_app/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:social_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_app/features/auth/presentation/bloc/auth_state.dart';

@GenerateMocks([
  LoginUseCase,
  RegisterUseCase,
  LogoutUseCase,
  GetCurrentUserUseCase,
  CheckAuthStatusUseCase,
])
import 'auth_bloc_test.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();

    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  final tUser = User(
    id: 'user123',
    email: 'test@example.com',
    username: 'testuser',
    createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
    updatedAt: DateTime.now(),
  );

  group('AuthCheckStatusRequested', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthAuthenticated] when user is authenticated',
      build: () {
        when(mockCheckAuthStatusUseCase()).thenAnswer((_) async => true);
        when(mockGetCurrentUserUseCase()).thenAnswer((_) async => Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [AuthLoading(), AuthAuthenticated(tUser)],
      verify: (_) {
        verify(mockCheckAuthStatusUseCase()).called(1);
        verify(mockGetCurrentUserUseCase()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthUnauthenticated] when user is not authenticated',
      build: () {
        when(mockCheckAuthStatusUseCase()).thenAnswer((_) async => false);
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
      verify: (_) {
        verify(mockCheckAuthStatusUseCase()).called(1);
        verifyNever(mockGetCurrentUserUseCase());
      },
    );
  });

  group('AuthLoginRequested', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthAuthenticated] when login is successful',
      build: () {
        when(
          mockLoginUseCase(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(email: tEmail, password: tPassword),
      ),
      expect: () => [AuthLoading(), AuthAuthenticated(tUser)],
      verify: (_) {
        verify(mockLoginUseCase(email: tEmail, password: tPassword)).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when login fails',
      build: () {
        when(
          mockLoginUseCase(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer(
          (_) async =>
              const Left(ServerFailure(message: 'Invalid credentials')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(email: tEmail, password: tPassword),
      ),
      expect: () => [AuthLoading(), const AuthError('Invalid credentials')],
    );
  });

  group('AuthRegisterRequested', () {
    const tEmail = 'test@example.com';
    const tUsername = 'testuser';
    const tPassword = 'password123';

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthAuthenticated] when registration is successful',
      build: () {
        when(
          mockRegisterUseCase(
            email: anyNamed('email'),
            username: anyNamed('username'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthRegisterRequested(
          email: tEmail,
          username: tUsername,
          password: tPassword,
        ),
      ),
      expect: () => [AuthLoading(), AuthAuthenticated(tUser)],
      verify: (_) {
        verify(
          mockRegisterUseCase(
            email: tEmail,
            username: tUsername,
            password: tPassword,
          ),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when registration fails',
      build: () {
        when(
          mockRegisterUseCase(
            email: anyNamed('email'),
            username: anyNamed('username'),
            password: anyNamed('password'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ValidationFailure(
              message: 'Email already exists',
              errors: {
                'email': ['Email already exists'],
              },
            ),
          ),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthRegisterRequested(
          email: tEmail,
          username: tUsername,
          password: tPassword,
        ),
      ),
      expect: () => [AuthLoading(), const AuthError('Email already exists')],
    );
  });

  group('AuthLogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthUnauthenticated] when logout is successful',
      build: () {
        when(mockLogoutUseCase()).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
      verify: (_) {
        verify(mockLogoutUseCase()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when logout fails',
      build: () {
        when(mockLogoutUseCase()).thenAnswer(
          (_) async =>
              const Left(CacheFailure(message: 'Failed to clear cache')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [AuthLoading(), const AuthError('Failed to clear cache')],
    );
  });
}
