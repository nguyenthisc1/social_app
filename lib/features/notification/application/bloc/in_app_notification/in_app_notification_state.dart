import 'package:social_app/features/notification/domain/entities/in_app_notification_entity.dart';

class InAppNotificationState {
  final List<InAppNotificationEntity> displayQueue;
  final InAppNotificationEntity? current;
  final List<InAppNotificationEntity> history;

  const InAppNotificationState({
    required this.displayQueue,
    this.current,
    required this.history,
  });

  int get unreadCount => history.where((n) => !n.isRead).length;

  InAppNotificationState copyWith({
    List<InAppNotificationEntity>? displayQueue,
    InAppNotificationEntity? current,
    bool clearCurrent = false,
    List<InAppNotificationEntity>? history,
  }) {
    return InAppNotificationState(
      displayQueue: displayQueue ?? this.displayQueue,
      current: clearCurrent ? null : current ?? this.current,
      history: history ?? this.history,
    );
  }
}
