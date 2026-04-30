import 'package:social_app/core/domain/exceptions/exception_base.dart';
import 'package:social_app/core/domain/exceptions/exception_factory.dart';

abstract class PostException extends ExceptionBase {
  const PostException({
    required super.userMessage,
    required super.debugMessage,
    required super.correlationId,
    super.cause,
    super.metadata,
  });
}

class PostCreateException extends PostException {
  @override
  final String code = 'POST.CREATE_FAILED';

  PostCreateException({
    super.userMessage = 'Unable to create post.',
    super.debugMessage = 'Failed to create post.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class PostUpdateException extends PostException {
  @override
  final String code = 'POST.UPDATE_FAILED';

  PostUpdateException({
    super.userMessage = 'Unable to update post.',
    super.debugMessage = 'Failed to update post.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class PostDeleteException extends PostException {
  @override
  final String code = 'POST.DELETE_FAILED';

  PostDeleteException({
    super.userMessage = 'Unable to delete post.',
    super.debugMessage = 'Failed to delete post.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class PostLoadException extends PostException {
  @override
  final String code = 'POST.LOAD_FAILED';

  PostLoadException({
    super.userMessage = 'Unable to load posts.',
    super.debugMessage = 'Failed to load post data.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}
