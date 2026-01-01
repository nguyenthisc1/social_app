import 'package:equatable/equatable.dart';

import 'package:social_app/core/entities/author_entity.dart';

class PostModel extends Equatable {
  final String id;
  final Author author;
  final String? content;
  final List<String>? images;
  final String type;
  final String? sharedPostId;
  final String visibility;
  final List<String> allowedUserIds;
  final int likeCount;
  final int commentCount;
  final String status;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  const PostModel({
    required this.id,
    required this.author,
    this.content,
    this.images,
    required this.type,
    this.sharedPostId,
    required this.visibility,
    required this.allowedUserIds,
    required this.likeCount,
    required this.commentCount,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      author: Author.fromJson(json['author']),
      content: json['content'],
      images: List<String>.from(json['images']),
      type: json['type'],
      sharedPostId: json['sharedPostId'],
      visibility: json['visibility'],
      allowedUserIds: List<String>.from(json['allowedUserIds']),
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      status: json['status'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      v: json['v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author.toJson(),
      'content': content,
      'images': images,
      'type': type,
      'sharedPostId': sharedPostId,
      'visibility': visibility,
      'allowedUserIds': allowedUserIds,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'status': status,
      'isDeleted': isDeleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'v': v,
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      author,
      content,
      images,
      type,
      sharedPostId,
      visibility,
      allowedUserIds,
      likeCount,
      commentCount,
      status,
      isDeleted,
      createdAt,
      updatedAt,
      v,
    ];
  }

  PostModel copyWith({
    String? id,
    Author? author,
    String? content,
    List<String>? images,
    String? type,
    String? sharedPostId,
    String? visibility,
    List<String>? allowedUserIds,
    int? likeCount,
    int? commentCount,
    String? status,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return PostModel(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      images: images ?? this.images,
      type: type ?? this.type,
      sharedPostId: sharedPostId ?? this.sharedPostId,
      visibility: visibility ?? this.visibility,
      allowedUserIds: allowedUserIds ?? this.allowedUserIds,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
