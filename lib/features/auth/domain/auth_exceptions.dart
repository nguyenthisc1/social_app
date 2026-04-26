import 'package:social_app/core/domain/exceptions/exception_base.dart';
import 'package:social_app/core/domain/exceptions/exception_factory.dart';

abstract class AuthException extends ExceptionBase {
  const AuthException({
    required super.userMessage,
    required super.debugMessage,
    required super.correlationId,
    super.cause,
    super.metadata,
  });
}

class AuthSignInException extends AuthException {
  @override
  final String code = 'AUTH.SIGN_IN_FAILED';

  AuthSignInException({
    super.userMessage = 'Sign in failed. Check your credentials.',
    super.debugMessage = 'Authentication sign-in failed.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class AuthSignUpException extends AuthException {
  @override
  final String code = 'AUTH.SIGN_UP_FAILED';

  AuthSignUpException({
    super.userMessage = 'Account creation failed.',
    super.debugMessage = 'Authentication sign-up failed.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class AuthSignOutException extends AuthException {
  @override
  final String code = 'AUTH.SIGN_OUT_FAILED';

  AuthSignOutException({
    super.userMessage = 'Sign out failed.',
    super.debugMessage = 'Authentication sign-out failed.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class AuthTokenException extends AuthException {
  @override
  final String code = 'AUTH.TOKEN_INVALID';

  AuthTokenException({
    super.userMessage = 'Your session has expired. Please sign in again.',
    super.debugMessage = 'Authentication token is invalid or expired.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class AuthPasswordResetException extends AuthException {
  @override
  final String code = 'AUTH.PASSWORD_RESET_FAILED';

  AuthPasswordResetException({
    super.userMessage = 'Password reset failed.',
    super.debugMessage = 'Authentication password reset operation failed.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class AuthUnauthorizedException extends AuthException {
  @override
  final String code = 'AUTH.UNAUTHORIZED';

  AuthUnauthorizedException({
    super.userMessage = 'You are not authorized to perform this action.',
    super.debugMessage = 'Unauthorized access attempt.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class AuthNotFoundException extends AuthException {
  @override
  final String code = 'AUTH.NOT_FOUND';

  AuthNotFoundException({
    super.userMessage = 'Authentication record not found.',
    super.debugMessage = 'Authentication resource could not be found.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}
