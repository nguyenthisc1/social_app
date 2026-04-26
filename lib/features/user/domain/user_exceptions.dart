import 'package:social_app/core/domain-base/exceptions/exception_base.dart';
import 'package:social_app/core/domain-base/exceptions/exception_factory.dart';

abstract class UserException extends ExceptionBase {
  const UserException({
    required super.userMessage,
    required super.debugMessage,
    required super.correlationId,
    super.cause,
    super.metadata,
  });
}

class UserNotFoundException extends UserException {
  @override
  final String code = 'USER.NOT_FOUND';

  UserNotFoundException({
    super.userMessage = 'User not found.',
    super.debugMessage = 'User document does not exist.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class UserLoadException extends UserException {
  @override
  final String code = 'USER.LOAD_FAILED';

  UserLoadException({
    super.userMessage = 'Unable to load user profile.',
    super.debugMessage = 'Failed to load user data.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class UserUpdateException extends UserException {
  @override
  final String code = 'USER.UPDATE_FAILED';

  UserUpdateException({
    super.userMessage = 'Unable to update user profile.',
    super.debugMessage = 'Failed to update user data.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class UserCacheException extends UserException {
  @override
  final String code = 'USER.CACHE_FAILED';

  UserCacheException({
    super.userMessage = 'Unable to load local user data.',
    super.debugMessage = 'User cache operation failed.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class UserSearchException extends UserException {
  @override
  final String code = 'USER.SEARCH_FAILED';

  UserSearchException({
    super.userMessage = 'Unable to search users.',
    super.debugMessage = 'User search operation failed.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}
