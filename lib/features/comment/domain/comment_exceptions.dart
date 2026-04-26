import 'package:social_app/core/domain-base/exceptions/exception_base.dart';
import 'package:social_app/core/domain-base/exceptions/exception_factory.dart';

abstract class CommentException extends ExceptionBase {
  const CommentException({
    required super.userMessage,
    required super.debugMessage,
    required super.correlationId,
    super.cause,
    super.metadata,
  });
}

class CommentCreateException extends CommentException {
  @override
  final String code = 'COMMENT.CREATE_FAILED';

  CommentCreateException({
    super.userMessage = 'Unable to post comment.',
    super.debugMessage = 'Failed to create comment.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class CommentUpdateException extends CommentException {
  @override
  final String code = 'COMMENT.UPDATE_FAILED';

  CommentUpdateException({
    super.userMessage = 'Unable to update comment.',
    super.debugMessage = 'Failed to update comment.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class CommentDeleteException extends CommentException {
  @override
  final String code = 'COMMENT.DELETE_FAILED';

  CommentDeleteException({
    super.userMessage = 'Unable to delete comment.',
    super.debugMessage = 'Failed to delete comment.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class CommentLoadException extends CommentException {
  @override
  final String code = 'COMMENT.LOAD_FAILED';

  CommentLoadException({
    super.userMessage = 'Unable to load comments.',
    super.debugMessage = 'Failed to load comment data.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class CommentNotFoundExcption extends CommentException {
  @override
  final String code = 'COMMENT.NOT_FOUND';

  CommentNotFoundExcption({
    super.userMessage = 'Comment not found.',
    super.debugMessage = 'Comment document does not exist.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}
