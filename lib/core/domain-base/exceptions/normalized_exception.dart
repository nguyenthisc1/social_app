class NormalizedException {
  final String code;
  final String userMessage;
  final String debugMessage;
  final String correlationId;
  final String? stack;
  final String? cause;
  final Map<String, Object?>? metadata;

  const NormalizedException({
    required this.code,
    required this.userMessage,
    required this.debugMessage,
    required this.correlationId,
    this.stack,
    this.cause,
    this.metadata,
  });
}
