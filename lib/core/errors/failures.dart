import 'package:equatable/equatable.dart';
import 'package:social_app/core/errors/exceptions.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failure for server-related errors
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Failure for cache-related errors
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Failure for network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({required super.message, this.errors});

  @override
  List<Object?> get props => [message, errors];
}

/// Failure for unauthorized access
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access',
    super.statusCode = 401,
  });
}

/// Failure for not found resources
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.statusCode = 404,
  });
}

Failure mapExceptionToFailure(Exception e) {
  if (e is NetworkException) {
    return NetworkFailure(message: e.message);
  }

  if (e is ValidationException) {
    return ValidationFailure(message: e.message, errors: e.errors);
  }

  if (e is UnauthorizedException) {
    return UnauthorizedFailure(message: e.message, statusCode: 401);
  }

  if (e is CacheException) {
    return CacheFailure(message: e.message);
  }

  if (e is ServerException) {
    return ServerFailure(message: e.message, statusCode: e.statusCode);
  }

  return const ServerFailure(message: 'Unexpected error occurred');
}
