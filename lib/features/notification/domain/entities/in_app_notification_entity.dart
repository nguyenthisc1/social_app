import 'package:social_app/features/notification/domain/entities/notification_types.dart';

class InAppNotificationEntity extends AppNoticationProps {
  final String id;

  const InAppNotificationEntity({
    required this.id,
    required super.type,
    required super.priority,
    required super.title,
    required super.body,
    required super.payload,
    required super.createdAt,
    required super.isRead,
    super.avatarUrl,
    super.thumbnailUrl,
  });

  InAppNotificationEntity copyWith({
    String? id,
    NotificationType? type,
    NotificationPriority? priority,
    String? title,
    String? body,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
    bool? isRead,
    String? avatarUrl,
    String? thumbnailUrl,
  }) {
    return InAppNotificationEntity(
      id: id ?? this.id,
      type: type ?? super.type,
      priority: priority ?? super.priority,
      title: title ?? super.title,
      body: body ?? super.body,
      payload: payload ?? super.payload,
      createdAt: createdAt ?? super.createdAt,
      isRead: isRead ?? super.isRead,
      avatarUrl: avatarUrl ?? super.avatarUrl,
      thumbnailUrl: thumbnailUrl ?? super.thumbnailUrl,
    );
  }
}
