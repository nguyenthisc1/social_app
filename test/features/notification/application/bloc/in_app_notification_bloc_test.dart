import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_bloc.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_event.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_state.dart';
import 'package:social_app/features/notification/domain/entities/in_app_notification_entity.dart';
import 'package:social_app/features/notification/domain/entities/notification_types.dart';

void main() {
  group('InAppNotificationBloc', () {
    InAppNotificationEntity notification(
      String id, {
      String title = 'Title',
      String body = 'Body',
      bool isRead = false,
      NotificationPriority priority = NotificationPriority.normal,
    }) {
      return InAppNotificationEntity(
        id: id,
        type: NotificationType.newMessage,
        priority: priority,
        title: title,
        body: body,
        payload: const {'conversationId': 'c1'},
        createdAt: DateTime(2026, 1, 1),
        isRead: isRead,
      );
    }

    blocTest<InAppNotificationBloc, InAppNotificationState>(
      'shows first notification immediately',
      build: InAppNotificationBloc.new,
      act: (bloc) => bloc.add(InAppNotificationReceived(notification('n1'))),
      expect: () => [
        InAppNotificationState(
          displayQueue: const [],
          current: notification('n1'),
          history: [notification('n1')],
        ),
      ],
    );

    blocTest<InAppNotificationBloc, InAppNotificationState>(
      'queues second notification while first is active',
      build: InAppNotificationBloc.new,
      act: (bloc) {
        bloc.add(InAppNotificationReceived(notification('n1')));
        bloc.add(InAppNotificationReceived(notification('n2')));
      },
      expect: () => [
        InAppNotificationState(
          displayQueue: const [],
          current: notification('n1'),
          history: [notification('n1')],
        ),
        InAppNotificationState(
          displayQueue: [notification('n2')],
          current: notification('n1'),
          history: [notification('n2'), notification('n1')],
        ),
      ],
    );

    blocTest<InAppNotificationBloc, InAppNotificationState>(
      'dismiss advances queue in FIFO order',
      build: InAppNotificationBloc.new,
      act: (bloc) {
        bloc.add(InAppNotificationReceived(notification('n1')));
        bloc.add(InAppNotificationReceived(notification('n2')));
        bloc.add(const InAppNotificationDismissed('n1'));
      },
      expect: () => [
        InAppNotificationState(
          displayQueue: const [],
          current: notification('n1'),
          history: [notification('n1')],
        ),
        InAppNotificationState(
          displayQueue: [notification('n2')],
          current: notification('n1'),
          history: [notification('n2'), notification('n1')],
        ),
        InAppNotificationState(
          displayQueue: const [],
          current: notification('n2'),
          history: [notification('n2'), notification('n1')],
        ),
      ],
    );

    blocTest<InAppNotificationBloc, InAppNotificationState>(
      'tap marks current notification as read before dismissing it',
      build: InAppNotificationBloc.new,
      act: (bloc) {
        final item = notification('n1');
        bloc.add(InAppNotificationReceived(item));
        bloc.add(InAppNotificationTapped(item));
      },
      expect: () => [
        InAppNotificationState(
          displayQueue: const [],
          current: notification('n1'),
          history: [notification('n1')],
        ),
        InAppNotificationState(
          displayQueue: const [],
          current: notification('n1'),
          history: [notification('n1', isRead: true)],
        ),
        InAppNotificationState(
          displayQueue: const [],
          current: null,
          history: [notification('n1', isRead: true)],
        ),
      ],
    );
  });
}
