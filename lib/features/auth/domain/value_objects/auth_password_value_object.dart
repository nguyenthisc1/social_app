import 'package:equatable/equatable.dart';

/// A value object representing a user's password for authentication.
/// Enforces basic validation rules and encapsulates the underlying value.
class AuthPasswordValueObject extends Equatable {
  final String value;

  /// Password must contain at least one uppercase letter.
  static final RegExp _passwordRegex = RegExp(r'^(?=.*[A-Z]).+$');

  const AuthPasswordValueObject._(this.value);

  /// Returns either [AuthPasswordValueObject] if valid, or `null` if invalid.
  static AuthPasswordValueObject? create(String input) {
    if (_isValid(input)) {
      return AuthPasswordValueObject._(input);
    }
    return null;
  }

  /// Checks the validity of the password format.
  static bool _isValid(String input) {
    return _passwordRegex.hasMatch(input);
  }

  /// Throws if invalid. Used for internal logic where invalid state is impossible.
  factory AuthPasswordValueObject(String input) {
    if (!_isValid(input)) {
      throw ArgumentError('Password does not meet security requirements.');
    }
    return AuthPasswordValueObject._(input);
  }

  @override
  List<Object?> get props => [value];
}
