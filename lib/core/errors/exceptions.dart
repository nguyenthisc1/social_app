abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException({required this.message, this.statusCode, this.data});

  @override
  String toString() =>
      '$runtimeType(message: $message, statusCode: $statusCode)';
}

class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode, super.data});
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection'})
    : super(statusCode: null);
}

class CacheException extends AppException {
  const CacheException({required super.message}) : super(statusCode: null);
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    required super.message,
    this.errors,
    super.statusCode = 422,
    super.data,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized access',
    super.statusCode = 401,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.statusCode = 404,
  });
}
