import 'package:flutter/material.dart';
import 'package:social_app/features/notification/domain/entities/in_app_notification_entity.dart';

class InAppNotificationBanner extends StatelessWidget {
  final InAppNotificationEntity notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const InAppNotificationBanner({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                  vertical: 12,
                  horizontal: 18,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar/Icon
                    CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: .08),
                      child: Icon(
                        Icons.notifications,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      radius: 22,
                    ),
                    const SizedBox(width: 14),
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
                          const SizedBox(height: 2),
                          Text(
                            notification.body,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Timestamp or Close button
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Dismiss',
                      onPressed: onDismiss,
                      splashRadius: 20,
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
