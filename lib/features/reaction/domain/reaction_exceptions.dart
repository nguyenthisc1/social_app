import 'package:social_app/core/domain/exceptions/exception_base.dart';
import 'package:social_app/core/domain/exceptions/exception_factory.dart';

abstract class ReactionException extends ExceptionBase {
  const ReactionException({
    required super.userMessage,
    required super.debugMessage,
    required super.correlationId,
    super.cause,
    super.metadata,
  });
}

class ReactionSubmitException extends ReactionException {
  @override
  final String code = 'REACTION.SUBMIT_FAILED';

  ReactionSubmitException({
    super.userMessage = 'Unable to submit reaction.',
    super.debugMessage = 'Failed to submit reaction.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class ReactionLoadException extends ReactionException {
  @override
  final String code = 'REACTION.LOAD_FAILED';

  ReactionLoadException({
    super.userMessage = 'Unable to load reactions.',
    super.debugMessage = 'Failed to load reaction data.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}
