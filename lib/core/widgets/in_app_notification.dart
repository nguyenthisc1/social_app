import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/widgets/in_app_notification_banner.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_bloc.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_event.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_state.dart';
import 'package:social_app/features/notification/domain/entities/in_app_notification_entity.dart';
import 'package:social_app/features/notification/domain/entities/notification_types.dart';

class InAppNotification extends StatefulWidget {
  final Widget child;
  const InAppNotification({super.key, required this.child});

  @override
  State<InAppNotification> createState() => _InAppNotificationState();
}

class _InAppNotificationState extends State<InAppNotification> {
  OverlayEntry? _overlayEntry;
  String? _visibleNotificationId;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InAppNotificationBloc, InAppNotificationState>(
      listenWhen: (prev, curr) => curr.current != prev.current,
      listener: (context, state) {
        if (state.current == null) {
          _removeOverlay();
          return;
        }

        _showNotification(context, state.current!);
      },
      child: widget.child,
    );
  }

  void _showNotification(
    BuildContext context,
    InAppNotificationEntity notification,
  ) {
    if (_visibleNotificationId == notification.id) {
      return;
    }

    _removeOverlay();

    final overlay = Overlay.of(context, rootOverlay: true);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => InAppNotificationBanner(
        notification: notification,
        onTap: () {
          context.read<InAppNotificationBloc>().add(
            InAppNotificationTapped(notification),
          );
          _removeOverlay();
          _handleNavigation(context, notification);
        },
        onDismiss: () {
          context.read<InAppNotificationBloc>().add(
            InAppNotificationDismissed(notification.id),
          );
          _removeOverlay();
        },
      ),
    );

    overlay.insert(entry);
    _overlayEntry = entry;
    _visibleNotificationId = notification.id;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _visibleNotificationId = null;
  }

  void _handleNavigation(
    BuildContext context,
    InAppNotificationEntity notification,
  ) {
    switch (notification.type) {
      case NotificationType.newMessage:
      case NotificationType.reactionMessage:
        // final convId = notification.payload['conversationId'];
        // context.push('/conversation/$convId');
        break;
      case NotificationType.friendRequest:
        // context.push('/friends/requests');
        break;
      case NotificationType.reactionPost:
        // final postId = notification.payload['postId'];
        // context.push('/post/$postId');
        break;
      default:
        break;
    }
  }
}
