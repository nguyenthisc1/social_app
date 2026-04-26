import 'package:social_app/core/domain/exceptions/exception_base.dart';
import 'package:social_app/core/domain/exceptions/exception_factory.dart';

abstract class FriendshipException extends ExceptionBase {
  const FriendshipException({
    required super.userMessage,
    required super.debugMessage,
    required super.correlationId,
    super.cause,
    super.metadata,
  });
}

class FriendshipRequestException extends FriendshipException {
  @override
  final String code = 'FRIENDSHIP.REQUEST_FAILED';

  FriendshipRequestException({
    super.userMessage = 'Unable to send friend request.',
    super.debugMessage = 'Failed to send friendship request.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class FriendshipAcceptException extends FriendshipException {
  @override
  final String code = 'FRIENDSHIP.ACCEPT_FAILED';

  FriendshipAcceptException({
    super.userMessage = 'Unable to accept friend request.',
    super.debugMessage = 'Failed to accept friendship request.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class FriendshipRejectException extends FriendshipException {
  @override
  final String code = 'FRIENDSHIP.REJECT_FAILED';

  FriendshipRejectException({
    super.userMessage = 'Unable to reject friend request.',
    super.debugMessage = 'Failed to reject friendship request.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class FriendshipLoadException extends FriendshipException {
  @override
  final String code = 'FRIENDSHIP.LOAD_FAILED';

  FriendshipLoadException({
    super.userMessage = 'Unable to load friends.',
    super.debugMessage = 'Failed to load friendship data.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class FriendshipStatusException extends FriendshipException {
  @override
  final String code = 'FRIENDSHIP.STATUS_FAILED';

  FriendshipStatusException({
    super.userMessage = 'Unable to check friendship status.',
    super.debugMessage = 'Failed to retrieve friendship status.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}
