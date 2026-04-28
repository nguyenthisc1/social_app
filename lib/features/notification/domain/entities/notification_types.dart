import 'package:equatable/equatable.dart';

enum NotificationType {
  newMessage,
  reactionMessage,
  reactionPost,
  friendRequest,
  friendAccepted,
  mentioned,
  groupInvite,
  missedCall,
}

enum NotificationPriority {
  low, // reaction, like
  normal, // new message
  high, // friend request, missed call
}

class AppNoticationProps extends Equatable {
  final NotificationType type;
  final NotificationPriority priority;
  final String title;
  final String body;
  final String? avatarUrl;
  final String? thumbnailUrl;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final bool isRead;

  const AppNoticationProps({
    required this.type,
    required this.priority,
    required this.title,
    required this.body,
    this.avatarUrl,
    this.thumbnailUrl,
    required this.payload,
    required this.createdAt,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
    type,
    priority,
    title,
    body,
    avatarUrl,
    thumbnailUrl,
    payload,
    createdAt,
    isRead,
  ];
}
