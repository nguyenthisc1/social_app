import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_app/core/widgets/app_notification.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_bloc.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_event.dart';
import 'package:social_app/features/notification/domain/entities/in_app_notification_entity.dart';
import 'package:social_app/features/notification/domain/entities/notification_types.dart';

void main() {
  InAppNotificationEntity notification(String id, String title) {
    return InAppNotificationEntity(
      id: id,
      type: NotificationType.newMessage,
      priority: NotificationPriority.normal,
      title: title,
      body: '$title body',
      payload: const {'conversationId': 'c1'},
      createdAt: DateTime(2026, 1, 1),
      isRead: false,
    );
  }

  testWidgets('shows current notification banner', (tester) async {
    final bloc = InAppNotificationBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const AppNotification(
            child: Scaffold(body: SizedBox.shrink()),
          ),
        ),
      ),
    );

    bloc.add(InAppNotificationReceived(notification('n1', 'First')));
    await tester.pump();
    await tester.pump();

    expect(find.text('First'), findsOneWidget);
    expect(find.text('First body'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('replaces banner when queue advances', (tester) async {
    final bloc = InAppNotificationBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const AppNotification(
            child: Scaffold(body: SizedBox.shrink()),
          ),
        ),
      ),
    );

    bloc.add(InAppNotificationReceived(notification('n1', 'First')));
    bloc.add(InAppNotificationReceived(notification('n2', 'Second')));
    await tester.pump();
    await tester.pump();

    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsNothing);

    bloc.add(const InAppNotificationDismissed('n1'));
    await tester.pump();
    await tester.pump();

    expect(find.text('First'), findsNothing);
    expect(find.text('Second'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('removes banner when current becomes null', (tester) async {
    final bloc = InAppNotificationBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const AppNotification(
            child: Scaffold(body: SizedBox.shrink()),
          ),
        ),
      ),
    );

    bloc.add(InAppNotificationReceived(notification('n1', 'First')));
    await tester.pump();
    await tester.pump();
    expect(find.text('First'), findsOneWidget);

    bloc.add(const InAppNotificationDismissed('n1'));
    await tester.pump();
    await tester.pump();

    expect(find.text('First'), findsNothing);
  });
}
