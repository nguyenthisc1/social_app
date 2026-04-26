import 'normalized_exception.dart';

abstract class ExceptionBase implements Exception {
  final String userMessage;
  final String debugMessage;
  final String correlationId;
  final Object? cause;
  final Map<String, Object?>? metadata;

  const ExceptionBase({
    required this.userMessage,
    required this.debugMessage,
    required this.correlationId,
    this.cause,
    this.metadata,
  });

  String get code;

  NormalizedException toNormalizedException({String? stackTrace}) {
    return NormalizedException(
      code: code,
      userMessage: userMessage,
      debugMessage: debugMessage,
      correlationId: correlationId,
      stack: stackTrace,
      cause: cause?.toString(),
      metadata: metadata,
    );
  }

  String toLogString({String? stackTrace}) {
    final normalized = toNormalizedException(stackTrace: stackTrace);
    return '[${normalized.code}] '
        '[${normalized.correlationId}] '
        '${normalized.debugMessage} '
        'cause=${normalized.cause} '
        'metadata=${normalized.metadata}';
  }

  @override
  String toString() => '$code: $debugMessage';
}
