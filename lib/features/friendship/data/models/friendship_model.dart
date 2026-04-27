import 'package:social_app/features/friendship/domain/entities/friendship_enums.dart';

/// Friendship model
class FriendshipModel {
  final String id;
  final String requesterId;
  final String receiverId;
  final FriendshipStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  FriendshipModel({
    required this.id,
    required this.requesterId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FriendshipModel.fromJson(Map<String, dynamic> json) {
    return FriendshipModel(
      id: json['_id'] as String,
      requesterId: json['requesterId'] is Map
          ? (json['requesterId'] as Map<String, dynamic>)['_id'] as String
          : json['requesterId'] as String,
      receiverId: json['receiverId'] is Map
          ? (json['receiverId'] as Map<String, dynamic>)['_id'] as String
          : json['receiverId'] as String,
      status: FriendshipStatusExtension.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'requesterId': requesterId,
      'receiverId': receiverId,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Friend request model with populated user data
class FriendRequestModel {
  final String id;
  final String requesterId;
  final String receiverId;
  final FriendshipStatus status;
  final String username;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  FriendRequestModel({
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

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    // Handle populated requester or receiver
    final requesterData = json['requesterId'] is Map
        ? json['requesterId'] as Map<String, dynamic>
        : null;
    final receiverData = json['receiverId'] is Map
        ? json['receiverId'] as Map<String, dynamic>
        : null;

    final userData = requesterData ?? receiverData ?? {};

    return FriendRequestModel(
      id: json['_id'] as String,
      requesterId: requesterData?['_id'] as String? ??
          json['requesterId'] as String,
      receiverId:
          receiverData?['_id'] as String? ?? json['receiverId'] as String,
      status: FriendshipStatusExtension.fromString(json['status'] as String),
      username: userData['username'] as String? ?? '',
      email: userData['email'] as String? ?? '',
      avatarUrl: userData['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'requesterId': requesterId,
      'receiverId': receiverId,
      'status': status.value,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Friendship response model
class FriendshipResponseModel {
  final bool success;
  final String message;

  FriendshipResponseModel({
    required this.success,
    required this.message,
  });

  factory FriendshipResponseModel.fromJson(Map<String, dynamic> json) {
    return FriendshipResponseModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}

/// Friend model (simplified user data)
class FriendModel {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;

  FriendModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
    };
  }
}

/// Friendship status model
class FriendshipStatusModel {
  final bool isFriend;
  final String message;

  FriendshipStatusModel({
    required this.isFriend,
    required this.message,
  });

  factory FriendshipStatusModel.fromJson(Map<String, dynamic> json) {
    return FriendshipStatusModel(
      isFriend: json['isFriend'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isFriend': isFriend,
      'message': message,
    };
  }
}
