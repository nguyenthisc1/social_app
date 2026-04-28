// notification_event.dart
import 'package:social_app/features/notification/domain/entities/in_app_notification_entity.dart';

sealed class InAppNotificationEvent {
  const InAppNotificationEvent();
}

class InAppNotificationReceived extends InAppNotificationEvent {
  final InAppNotificationEntity notification;
  const InAppNotificationReceived(this.notification);
}

class InAppNotificationDismissed extends InAppNotificationEvent {
  final String notificationId;
  const InAppNotificationDismissed(this.notificationId);
}

class InAppNotificationTapped extends InAppNotificationEvent {
  final InAppNotificationEntity notification;
  const InAppNotificationTapped(this.notification);
}

class InAppNotificationMarkedAsRead extends InAppNotificationEvent {
  final String notificationId;
  const InAppNotificationMarkedAsRead(this.notificationId);
}

class InAppAllNotificationsCleared extends InAppNotificationEvent {}

class InAppNotificationAutoDismiss extends InAppNotificationEvent {
  final String notificationId;
  const InAppNotificationAutoDismiss(this.notificationId);
}
