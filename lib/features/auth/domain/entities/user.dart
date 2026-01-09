import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user
class User extends Equatable {
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

  const User({
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

  /// Create a copy with updated fields
  User copyWith({
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
    return User(
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

