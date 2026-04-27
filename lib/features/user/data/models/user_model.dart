import 'package:cloud_firestore/cloud_firestore.dart';
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
  final Timestamp lastSeen;
  final Timestamp createdAt;
  final bool isOnline;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.friends = const [],
    this.following = const [],
    this.followers = const [],
    required this.lastSeen,
    required this.createdAt,
    this.isOnline = false,
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
    lastSeen,
    createdAt,
    isOnline,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'friends': friends,
      'following': following,
      'followers': followers,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'isOnline': isOnline,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      friends: List<String>.from(json['friends'] ?? []),
      following: List<String>.from(json['following'] ?? []),
      followers: List<String>.from(json['followers'] ?? []),
      lastSeen: json['lastSeen'] is Timestamp
          ? json['lastSeen']
          : Timestamp.fromMillisecondsSinceEpoch(
              (json['lastSeen']?['millisecondsSinceEpoch']) ??
                  DateTime.now().millisecondsSinceEpoch,
            ),
      createdAt: json['createdAt'] is Timestamp
          ? json['createdAt']
          : Timestamp.fromMillisecondsSinceEpoch(
              (json['createdAt']?['millisecondsSinceEpoch']) ??
                  DateTime.now().millisecondsSinceEpoch,
            ),
      isOnline: json['isOnline'] ?? false,
    );
  }
}
