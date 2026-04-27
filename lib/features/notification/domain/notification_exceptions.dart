import 'package:social_app/core/domain-base/exceptions/exception_base.dart';
import 'package:social_app/core/domain-base/exceptions/exception_factory.dart';

abstract class NotificationException extends ExceptionBase {
  const NotificationException({
    required super.userMessage,
    required super.debugMessage,
    required super.correlationId,
    super.cause,
    super.metadata,
  });
}

class NotificationPermissionException extends NotificationException {
  @override
  final String code = 'NOTIFICATION.PERMISSION_DENIED';

  NotificationPermissionException({
    super.userMessage = 'Notification permission was denied.',
    super.debugMessage = 'Failed to request notification permission.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class NotificationTokenException extends NotificationException {
  @override
  final String code = 'NOTIFICATION.TOKEN_FAILED';

  NotificationTokenException({
    super.userMessage = 'Unable to retrieve notification token.',
    super.debugMessage = 'Failed to get FCM device token.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}

class NotificationSyncException extends NotificationException {
  @override
  final String code = 'NOTIFICATION.SYNC_FAILED';

  NotificationSyncException({
    super.userMessage = 'Unable to sync notification settings.',
    super.debugMessage = 'Failed to sync device FCM token.',
    super.cause,
    super.metadata,
  }) : super(correlationId: newCorrelationId());
}
