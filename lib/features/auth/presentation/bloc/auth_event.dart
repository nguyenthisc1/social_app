import 'package:equatable/equatable.dart';

/// Base class for auth events
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

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

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
class AuthLogoutRequested extends AuthEvent {}

/// Event to get current user
class AuthGetCurrentUserRequested extends AuthEvent {}

