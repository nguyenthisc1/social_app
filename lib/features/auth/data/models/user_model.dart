import 'package:equatable/equatable.dart';

/// User model with JSON serialization
class UserModel extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final List<String> friends;
  final List<String> following;
  final List<String> followers;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.friends = const [],
    this.following = const [],
    this.followers = const [],
    this.isActive = false,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        avatarUrl,
        bio,
        friends,
        following,
        followers,
        isActive,
        createdAt,
        updatedAt,
      ];

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      friends: (json['friends'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      following: (json['following'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      followers: (json['followers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isActive: json['isActive'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'friends': friends,
      'following': following,
      'followers': followers,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    String? bio,
    List<String>? friends,
    List<String>? following,
    List<String>? followers,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      friends: friends ?? this.friends,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

