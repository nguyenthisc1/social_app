import 'package:social_app/core/domain-base/exceptions/exception-base.dart';

/// A base exception class for authentication errors.
abstract class AuthException extends ExceptionBase {
  const AuthException({
    required super.message,
    super.code,
    super.correlationId,
    super.cause,
    super.metadata,
  });
}

/// Exception thrown when sign in fails due to invalid credentials.
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException({
    super.message = 'Invalid credentials provided.',
    String? code,
    super.correlationId,
    super.cause,
    super.metadata,
  }) : super(code: code ?? 'invalid_credentials');
}

/// Exception thrown when sign up fails due to an already existing user.
class UserAlreadyExistsException extends AuthException {
  const UserAlreadyExistsException({
    super.message = 'User already exists.',
    String? code,
    super.correlationId,
    super.cause,
    super.metadata,
  }) : super(code: code ?? 'user_already_exists');
}

/// Exception thrown when sign in fails due to user not being found.
class UserNotFoundException extends AuthException {
  const UserNotFoundException({
    super.message = 'User not found.',
    String? code,
    super.correlationId,
    super.cause,
    super.metadata,
  }) : super(code: code ?? 'user_not_found');
}

/// Exception thrown when a user's account is disabled.
class UserDisabledException extends AuthException {
  const UserDisabledException({
    super.message = 'User account is disabled.',
    String? code,
    super.correlationId,
    super.cause,
    super.metadata,
  }) : super(code: code ?? 'user_disabled');
}

/// Exception thrown when a password is too weak during registration.
class WeakPasswordException extends AuthException {
  const WeakPasswordException({
    super.message = 'Password is too weak.',
    String? code,
    super.correlationId,
    super.cause,
    super.metadata,
  }) : super(code: code ?? 'weak_password');
}

/// Exception thrown when an invalid or expired token is used.
class InvalidTokenException extends AuthException {
  const InvalidTokenException({
    super.message = 'Invalid or expired authentication token.',
    String? code,
    super.correlationId,
    super.cause,
    super.metadata,
  }) : super(code: code ?? 'invalid_token');
}

/// Exception thrown when too many requests are made in a given period.
class TooManyRequestsException extends AuthException {
  const TooManyRequestsException({
    super.message = 'Too many authentication attempts. Try again later.',
    String? code,
    super.correlationId,
    super.cause,
    super.metadata,
  }) : super(code: code ?? 'too_many_requests');
}

/// Exception thrown for unknown or unhandled authentication errors.
class UnknownAuthException extends AuthException {
  const UnknownAuthException({
    super.message = 'An unknown authentication error occurred.',
    String? code,
    super.correlationId,
    super.cause,
    super.metadata,
  }) : super(code: code ?? 'unknown_auth_error');
}
