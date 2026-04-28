import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_event.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_state.dart';
import 'package:social_app/features/notification/domain/entities/in_app_notification_entity.dart';
import 'package:social_app/features/notification/domain/entities/notification_types.dart';

class InAppNotificationBloc
    extends Bloc<InAppNotificationEvent, InAppNotificationState> {
  final Map<String, Timer> _dismissTimers = {};

  static const _dismissDuration = {
    NotificationPriority.low: Duration(seconds: 2),
    NotificationPriority.normal: Duration(seconds: 4),
    NotificationPriority.high: Duration(seconds: 6),
  };

  InAppNotificationBloc()
    : super(const InAppNotificationState(displayQueue: [], history: [])) {
    on<InAppNotificationReceived>(_onReceived);
    on<InAppNotificationDismissed>(_onDismissed);
    on<InAppNotificationTapped>(_onTapped);
    on<InAppNotificationMarkedAsRead>(_onMarkedAsRead);
    on<InAppAllNotificationsCleared>(_onAllCleared);
    on<InAppNotificationAutoDismiss>(_onAutoDismiss);
  }

  void _onReceived(InAppNotificationReceived event, Emitter emit) {
    final notification = event.notification;

    final updatedHistory = [notification, ...state.history];

    //  if have notification
    if (state.current != null) {
      emit(
        state.copyWith(
          displayQueue: [...state.displayQueue, notification],
          history: updatedHistory,
        ),
      );
      return;
    }

    // if not notification show current
    _showAndScheduleDismiss(notification, emit);
    emit(state.copyWith(current: notification, history: updatedHistory));
  }

  void _onDismissed(InAppNotificationDismissed event, Emitter emit) {
    _dismissTimers.remove(event.notificationId)?.cancel();
    add(InAppNotificationAutoDismiss(event.notificationId));
  }

  void _onTapped(InAppNotificationTapped event, Emitter emit) {
    // update is read
    add(InAppNotificationMarkedAsRead(event.notification.id));

    // when is read dismissed
    add(InAppNotificationDismissed(event.notification.id));
  }

  void _onMarkedAsRead(InAppNotificationMarkedAsRead event, Emitter emit) {
    final updatedHistory = state.history
        .map((n) => n.id == event.notificationId ? n.copyWith(isRead: true) : n)
        .toList();

    emit(state.copyWith(history: updatedHistory));
  }

  void _onAutoDismiss(InAppNotificationAutoDismiss event, Emitter emit) {
    if (state.current?.id != event.notificationId) return;

    _dismissTimers.remove(event.notificationId)?.cancel();

    // have notification in queue → show next notification
    if (state.displayQueue.isNotEmpty) {
      final next = state.displayQueue.first;
      final remaining = state.displayQueue.skip(1).toList();
      _showAndScheduleDismiss(next, emit);
      emit(state.copyWith(current: next, displayQueue: remaining));
    } else {
      emit(state.copyWith(clearCurrent: true));
    }
  }

  void _onAllCleared(InAppAllNotificationsCleared event, Emitter emit) {
    for (final timer in _dismissTimers.values) {
      timer.cancel();
    }
    _dismissTimers.clear();
    emit(const InAppNotificationState(displayQueue: [], history: []));
  }

  void _showAndScheduleDismiss(
    InAppNotificationEntity notification,
    Emitter emit,
  ) {
    final duration = _dismissDuration[notification.priority]!;
    _dismissTimers[notification.id] = Timer(duration, () {
      add(InAppNotificationAutoDismiss(notification.id));
    });
  }

  @override
  Future<void> close() {
    for (final timer in _dismissTimers.values) {
      timer.cancel();
    }
    return super.close();
  }
}
