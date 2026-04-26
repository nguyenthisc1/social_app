import 'exception_base.dart';
import 'exception_codes.dart';
import 'exception_factory.dart';

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
