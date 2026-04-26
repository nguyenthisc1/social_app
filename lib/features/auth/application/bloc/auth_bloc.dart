import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/domain/exceptions/exception_base.dart';
import 'package:social_app/core/domain/usecases/usecases.dart';
import 'package:social_app/features/auth/domain/auth_types.dart';
import 'package:social_app/features/user/domain/entites/user_entity.dart';

import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check authentication status
class AuthCheckRequested extends AuthEvent {}

/// Event for user login
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event for user registration
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String username;
  final String password;

  const AuthRegisterRequested({
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [email, username, password];
}

/// Event for user logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Event to get current user
class AuthGetCurrentUserRequested extends AuthEvent {}

/// New: Event state shows last event (for debugging/logging/UI)
class AuthEventState extends AuthState {
  final AuthEvent lastEvent;

  const AuthEventState(this.lastEvent);

  @override
  List<Object?> get props => [lastEvent];
}

/// Base class for auth states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state that triggers an authentication status check on Bloc creation.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state
class AuthLoading extends AuthState {}

/// Authenticated state
class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state
class AuthUnauthenticated extends AuthState {}

/// Error state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.checkAuthStatusUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthGetCurrentUserRequested>(_onAuthGetCurrentUserRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthEventState(event));
    emit(AuthLoading());

    final authenticated = await checkAuthStatusUseCase(NoParams());

    if (authenticated) {
      try {
        final user = await getCurrentUserUseCase(NoParams());
        emit(AuthAuthenticated(user));
      } catch (_) {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthEventState(event));
    emit(AuthLoading());

    try {
      final user = await loginUseCase(
        LoginCommand(email: event.email, password: event.password),
      );
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(_mapErrorMessage(error)));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthEventState(event));
    emit(AuthLoading());

    try {
      final user = await registerUseCase(
        RegisterCommand(
          email: event.email,
          username: event.username,
          password: event.password,
        ),
      );
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(_mapErrorMessage(error)));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthEventState(event));
    emit(AuthLoading());

    try {
      await logoutUseCase(NoParams());
      emit(AuthUnauthenticated());
    } catch (error) {
      emit(AuthError(_mapErrorMessage(error)));
    }
  }

  Future<void> _onAuthGetCurrentUserRequested(
    AuthGetCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthEventState(event));
    emit(AuthLoading());

    try {
      final user = await getCurrentUserUseCase(NoParams());
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(_mapErrorMessage(error)));
    }
  }

  String _mapErrorMessage(Object error) {
    if (error is ExceptionBase) {
      return error.userMessage;
    }

    return 'Something went wrong.';
  }
}
