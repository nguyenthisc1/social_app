import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/app/routes/app_routes.dart';
import 'package:social_app/core/theme/app_size.dart';
import 'package:social_app/core/utils/extensions.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_bloc.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_event.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_state.dart';
import 'package:social_app/features/notification/domain/entities/in_app_notification_entity.dart';
import 'package:social_app/features/notification/domain/entities/notification_types.dart';

class InAppNotificationBanner extends StatefulWidget {
  const InAppNotificationBanner({super.key});

  @override
  State<InAppNotificationBanner> createState() =>
      _InAppNotificationBannerState();
}

class _InAppNotificationBannerState extends State<InAppNotificationBanner> {
  late FToast _fToast;

  static const _dismissDuration = {
    NotificationPriority.low: Duration(seconds: 2),
    NotificationPriority.normal: Duration(seconds: 4),
    NotificationPriority.high: Duration(seconds: 6),
  };

  @override
  void initState() {
    super.initState();
    _fToast = FToast();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fToast.init(context);
  }

  void _showToast(BuildContext context, InAppNotificationEntity notification) {
    // Clean foast for stack case
    _fToast.removeCustomToast();
    _fToast.removeQueuedCustomToasts();

    Widget toast = _NotificationBanner(
      notification: notification,
      onTap: () {
        _fToast.removeCustomToast();
        _fToast.removeQueuedCustomToasts();

        context.read<InAppNotificationBloc>().add(
          InAppNotificationTapped(notification),
        );
        _handleNavigation(context, notification);
      },
      onDismiss: () {
        _fToast.removeCustomToast();
        _fToast.removeQueuedCustomToasts();

        context.read<InAppNotificationBloc>().add(
          InAppNotificationDismissed(notification.id),
        );
      },
    );

    _fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: _dismissDuration[notification.priority]!,
    );
  }

  void _handleNavigation(
    BuildContext context,
    InAppNotificationEntity notification,
  ) {
    switch (notification.type) {
      case NotificationType.newMessage:
        final conversationId = notification.payload['conversationId'];
        context.push('${AppRoutes.chat}/$conversationId');

      case NotificationType.reactionMessage:
        break;
      case NotificationType.friendRequest:
        break;
      case NotificationType.reactionPost:
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InAppNotificationBloc, InAppNotificationState>(
      listenWhen: (previous, current) =>
          current.current != null && previous.current != current.current,
      listener: (context, state) {
        final notification = state.current;
        if (notification != null) {
          _showToast(context, notification);
        }
      },
      child: SizedBox.shrink(),
    );
  }
}

class _NotificationBanner extends StatelessWidget {
  final InAppNotificationEntity notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const _NotificationBanner({
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    print('asddas ${notification.payload['conversationName']}');

    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSize.md),
        child: GestureDetector(
          onTap: onTap,
          child: Dismissible(
            key: ValueKey(notification.id),
            direction: DismissDirection.up,
            onDismissed: (_) {
              if (onDismiss != null) onDismiss!();
            },
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface,
              elevation: 8,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSize.lg,
                  horizontal: AppSize.xl,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar/Icon
                    CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: .08),
                      backgroundImage:
                          notification.avatarUrl?.isNotEmpty == true
                          ? NetworkImage(notification.avatarUrl!)
                          : null,
                      radius: AppSize.borderRadiusLarge,
                      child: notification.avatarUrl?.isNotEmpty == true
                          ? null
                          : Text(
                              notification.payload['conversationName'],
                              style: context.textTheme.titleMedium,
                            ),
                    ),
                    const SizedBox(width: AppSize.lg),
                    // Notification Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSize.xs),
                          Text(
                            notification.body,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
