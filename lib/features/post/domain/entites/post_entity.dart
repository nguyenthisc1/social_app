import 'package:equatable/equatable.dart';

import 'package:social_app/core/entities/author_entity.dart';
import 'package:social_app/features/post/domain/entites/post_enum.dart';

class PostEntity extends Equatable {
  final String id;
  final Author author;
  final String? content;
  final List<String>? images;
  final PostType type;
  final String? sharedPostId;
  final PostVisibility visibility;
  final List<String> allowedUserIds;
  final int likeCount;
  final int commentCount;
  final PostStatus status;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  const PostEntity({
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

  @override
  List<Object?> get props => [
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
    updatedAt,
    v,
  ];

  PostEntity copyWith({
    String? id,
    Author? author,
    String? content,
    List<String>? images,
    PostType? type,
    String? sharedPostId,
    PostVisibility? visibility,
    List<String>? allowedUserIds,
    int? likeCount,
    int? commentCount,
    PostStatus? status,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return PostEntity(
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
