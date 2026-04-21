import 'package:social_app/core/domain-base/exceptions/exception-base.dart';

/// Thrown when user-related errors occur.
class UserException extends ExceptionBase {
  const UserException({
    required super.message,
    super.code,
    super.correlationId,
    super.cause,
    super.metadata,
  });
}

/// Specific exception indicating the user was not found.
class UserNotFoundException extends UserException {
  const UserNotFoundException({
    super.message = 'User not found.',
    super.code = 'user_not_found',
    super.correlationId,
    super.cause,
    super.metadata,
  });
}

/// Specific exception indicating duplicate user (e.g., duplicate email/username).
class DuplicateUserException extends UserException {
  const DuplicateUserException({
    super.message = 'Duplicate user.',
    super.code = 'duplicate_user',
    super.correlationId,
    super.cause,
    super.metadata,
  });
}

/// Specific exception for failed user validation or malformed data.
class UserValidationException extends UserException {
  const UserValidationException({
    super.message = 'User validation failed.',
    super.code = 'user_validation_failed',
    super.correlationId,
    super.cause,
    super.metadata,
  });
}
