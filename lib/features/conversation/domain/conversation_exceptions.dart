import 'package:social_app/core/domain-base/exceptions/exception_base.dart';
import 'package:social_app/core/domain-base/exceptions/exception_factory.dart';

abstract class ConversationException extends ExceptionBase {
  const ConversationException({
    required super.userMessage,
    required super.debugMessage,
    required super.correlationId,
    super.cause,
    super.metadata,
  });
}

class ConversationCreateException extends ConversationException {
  @override
  final String code = 'CONVERSATION.CREATE_FAILED';

  ConversationCreateException({
    super.userMessage = 'Unable to create conversation.',
    super.debugMessage = 'Failed to create conversation.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class ConversationLoadException extends ConversationException {
  @override
  final String code = 'CONVERSATION.LOAD_FAILED';

  ConversationLoadException({
    super.userMessage = 'Unable to load conversations.',
    super.debugMessage = 'Failed to load conversations.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class ConversationWatchException extends ConversationException {
  @override
  final String code = 'CONVERSATION.WATCH_FAILED';

  ConversationWatchException({
    super.userMessage = 'Unable to sync conversations.',
    super.debugMessage = 'Conversation realtime watch failed.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}
