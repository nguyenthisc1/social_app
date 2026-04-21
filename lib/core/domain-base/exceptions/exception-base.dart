/// A normalized representation of exceptions throughout the application.
/// Add more fields if additional context or metadata is needed for debugging.
class NormalizedException {
  final String message;
  final String code;
  final String correlationId;
  final String? stack;
  final String? cause;
  final Map<String, dynamic>? metadata;

  const NormalizedException({
    required this.message,
    required this.code,
    required this.correlationId,
    this.stack,
    this.cause,
    this.metadata,
  });
}

abstract class ExceptionBase implements Exception {
  /// Human-readable error message.
  final String message;

  /// Optional error code for additional context.
  final String? code;

  /// Optional correlation ID for distributed tracing.
  final String? correlationId;

  /// Optional root cause (technical details or internal error string).
  final String? cause;

  /// Optional metadata for debugging or context.
  final Map<String, dynamic>? metadata;

  const ExceptionBase({
    required this.message,
    this.code,
    this.correlationId,
    this.cause,
    this.metadata,
  });

  /// Convert this exception to a normalized exception object.
  NormalizedException toNormalizedException({String? stack}) {
    return NormalizedException(
      message: message,
      code: code ?? 'unknown',
      correlationId: correlationId ?? '',
      stack: stack,
      cause: cause,
      metadata: metadata,
    );
  }

  @override
  String toString() => '$runtimeType: $message';
}
