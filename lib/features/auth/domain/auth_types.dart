import 'package:equatable/equatable.dart';

class LoginCommand extends Equatable {
  final String email;
  final String password;

  const LoginCommand({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterCommand extends Equatable {
  final String email;
  final String username;
  final String password;

  const RegisterCommand({
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [email, username, password];
}
