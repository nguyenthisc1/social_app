import 'package:equatable/equatable.dart';

class AuthEmailValueObject extends Equatable {
  final String value;

  static final RegExp _emailRegExp = RegExp(
    r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$",
  );

  const AuthEmailValueObject._(this.value);

  factory AuthEmailValueObject(String input) {
    if (!_isValidEmail(input)) {
      throw ArgumentError('Invalid email address');
    }
    return AuthEmailValueObject._(input.trim());
  }

  static bool _isValidEmail(String input) {
    return input.isNotEmpty && _emailRegExp.hasMatch(input);
  }

  @override
  List<Object> get props => [value];
}
