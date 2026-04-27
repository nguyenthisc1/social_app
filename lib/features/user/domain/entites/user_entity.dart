import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final List<String> friends;
  final List<String> following;
  final List<String> followers;
  final Timestamp lastSeen;
  final Timestamp createdAt;
  final bool isOnline;

  const UserEntity({
  required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.friends = const [],
    this.following = const [],
    this.followers = const [],
    this.isOnline = false,
    required this.lastSeen,
    required this.createdAt,
  });

  UserEntity copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    String? bio,
    List<String>? friends,
    List<String>? following,
    List<String>? followers,
    Timestamp? lastSeen,
    Timestamp? createdAt,
    bool? isOnline,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      friends: friends ?? this.friends,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      isOnline: isOnline ?? this.isOnline,
    );
  }

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
    lastSeen,
    createdAt,
    isOnline,
  ];
}
