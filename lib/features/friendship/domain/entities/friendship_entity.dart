import 'package:equatable/equatable.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_enums.dart';

/// Friendship entity representing a friend request or friendship
class FriendshipEntity extends Equatable {
  final String id;
  final String requesterId;
  final String receiverId;
  final FriendshipStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FriendshipEntity({
    required this.id,
    required this.requesterId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        requesterId,
        receiverId,
        status,
        createdAt,
        updatedAt,
      ];

  FriendshipEntity copyWith({
    String? id,
    String? requesterId,
    String? receiverId,
    FriendshipStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FriendshipEntity(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Friend request with populated user data
class FriendRequestEntity extends Equatable {
  final String id;
  final String requesterId;
  final String receiverId;
  final FriendshipStatus status;
  final String username;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FriendRequestEntity({
    required this.id,
    required this.requesterId,
    required this.receiverId,
    required this.status,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        requesterId,
        receiverId,
        status,
        username,
        email,
        avatarUrl,
        createdAt,
        updatedAt,
      ];
}

/// Friendship response entity
class FriendshipResponseEntity extends Equatable {
  final bool success;
  final String message;

  const FriendshipResponseEntity({
    required this.success,
    required this.message,
  });

  @override
  List<Object?> get props => [success, message];
}

/// Friend entity (simplified user data)
class FriendEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;

  const FriendEntity({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
  });

  @override
  List<Object?> get props => [id, username, email, avatarUrl, bio];
}

/// Friendship status check entity
class FriendshipStatusEntity extends Equatable {
  final bool isFriend;
  final String message;

  const FriendshipStatusEntity({
    required this.isFriend,
    required this.message,
  });

  @override
  List<Object?> get props => [isFriend, message];
}
