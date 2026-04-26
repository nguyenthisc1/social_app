import 'package:social_app/core/domain-base/exceptions/exception_base.dart';
import 'package:social_app/core/domain-base/exceptions/exception_factory.dart';

abstract class MessageException extends ExceptionBase {
  const MessageException({
    required super.userMessage,
    required super.debugMessage,
    required super.correlationId,
    super.cause,
    super.metadata,
  });
}

class MessageSendException extends MessageException {
  @override
  final String code = 'MESSAGE.SEND_FAILED';

  MessageSendException({
    super.userMessage = 'Unable to send message.',
    super.debugMessage = 'Failed to send message.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class MessageLoadException extends MessageException {
  @override
  final String code = 'MESSAGE.LOAD_FAILED';

  MessageLoadException({
    super.userMessage = 'Unable to load messages.',
    super.debugMessage = 'Failed to load messages.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class MessageCacheException extends MessageException {
  @override
  final String code = 'MESSAGE.CACHE_FAILED';

  MessageCacheException({
    super.userMessage = 'Unable to load cached messages.',
    super.debugMessage = 'Message cache operation failed.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class MessageWatchException extends MessageException {
  @override
  final String code = 'MESSAGE.WATCH_FAILED';

  MessageWatchException({
    super.userMessage = 'Unable to sync messages.',
    super.debugMessage = 'Message realtime watch failed.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}
