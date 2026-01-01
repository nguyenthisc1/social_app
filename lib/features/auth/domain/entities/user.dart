import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user
class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? displayName;
  final String? bio;
  final String? avatarUrl;
  final String? coverImageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isVerified;
  final bool isPrivate;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.bio,
    this.avatarUrl,
    this.coverImageUrl,
    required this.createdAt,
    this.updatedAt,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isVerified = false,
    this.isPrivate = false,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        displayName,
        bio,
        avatarUrl,
        coverImageUrl,
        createdAt,
        updatedAt,
        followersCount,
        followingCount,
        postsCount,
        isVerified,
        isPrivate,
      ];

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? bio,
    String? avatarUrl,
    String? coverImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    bool? isVerified,
    bool? isPrivate,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      isVerified: isVerified ?? this.isVerified,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}

