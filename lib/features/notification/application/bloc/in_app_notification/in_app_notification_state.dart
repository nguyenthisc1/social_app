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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InAppNotificationState &&
        _listEquals(other.displayQueue, displayQueue) &&
        other.current == current &&
        _listEquals(other.history, history);
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(displayQueue),
    current,
    Object.hashAll(history),
  );

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
