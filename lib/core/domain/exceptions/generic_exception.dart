import 'exception_base.dart';
import 'exception_codes.dart';
import 'exception_factory.dart';

class ArgumentNotProvidedException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.argumentNotProvided;

  ArgumentNotProvidedException({
    required super.userMessage,
    required super.debugMessage,
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class ArgumentInvalidException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.invalidArgument;

  ArgumentInvalidException({
    required super.userMessage,
    required super.debugMessage,
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class NetworkException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.network;

  NetworkException({
    super.userMessage = 'Network connection is unstable.',
    super.debugMessage = 'Network request failed.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class CacheException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.cache;

  CacheException({
    super.userMessage = 'Unable to load local data.',
    super.debugMessage = 'Cache operation failed.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class NotFoundException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.notFound;

  NotFoundException({
    super.userMessage = 'Data not found.',
    super.debugMessage = 'Requested entity was not found.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

// ======== Server Exceptions ========

class ServerException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.server;

  ServerException({
    super.userMessage = 'Server error occurred.',
    super.debugMessage = 'A generic server error was encountered.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class UnauthorizedException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.unauthorized;

  UnauthorizedException({
    super.userMessage = 'Unauthorized access.',
    super.debugMessage = 'User is not authorized.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class ForbiddenException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.forbidden;

  ForbiddenException({
    super.userMessage = 'Action is forbidden.',
    super.debugMessage = 'User attempted an operation without permission.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class BadRequestException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.badRequest;

  BadRequestException({
    super.userMessage = 'Invalid request.',
    super.debugMessage = 'The server could not process the request.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class ConflictException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.conflict;

  ConflictException({
    super.userMessage = 'Conflict occurred.',
    super.debugMessage = 'Request could not be completed due to a conflict.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class TooManyRequestsException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.tooManyRequests;

  TooManyRequestsException({
    super.userMessage = 'Too many requests. Please slow down.',
    super.debugMessage = 'Rate limit exceeded.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class ServiceUnavailableException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.serviceUnavailable;

  ServiceUnavailableException({
    super.userMessage = 'Service is temporarily unavailable.',
    super.debugMessage =
        'The server is currently unable to handle the request.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

// ======== Generic/Unknown Exception ========

class UnknownException extends ExceptionBase {
  @override
  final String code = ExceptionCodes.unknown;

  UnknownException({
    super.userMessage = 'Something went wrong.',
    super.debugMessage = 'Unexpected exception occurred.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}
