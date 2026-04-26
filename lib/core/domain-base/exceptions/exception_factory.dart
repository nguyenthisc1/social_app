import 'dart:math';

String newCorrelationId() {
  final random = Random();
  final now = DateTime.now().millisecondsSinceEpoch;
  return '$now-${random.nextInt(999999)}';
}
