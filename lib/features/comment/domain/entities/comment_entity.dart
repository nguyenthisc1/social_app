import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String postId;
  final String? parentCommentId;
  final String content;
  final int likeCount;
  final String authorId;
  final bool isDeleted;
  final DateTime? deletedAt;
  final bool isEdited;

  const CommentEntity({
    required this.postId,
    this.parentCommentId,
    required this.content,
    this.likeCount = 0,
    required this.authorId,
    this.isDeleted = false,
    this.deletedAt,
    this.isEdited = false,
  });

  CommentEntity copyWith({
    String? postId,
    String? parentCommentId,
    String? content,
    int? likeCount,
    String? authorId,
    bool? isDeleted,
    DateTime? deletedAt,
    bool? isEdited,
  }) {
    return CommentEntity(
      postId: postId ?? this.postId,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      content: content ?? this.content,
      likeCount: likeCount ?? this.likeCount,
      authorId: authorId ?? this.authorId,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  factory CommentEntity.fromJson(Map<String, dynamic> json) {
    return CommentEntity(
      postId: json['postId'],
      parentCommentId: json['parentCommentId'],
      content: json['content'],
      likeCount: json['likeCount'],
      authorId: json['authorId'],
      isDeleted: json['isDeleted'],
      deletedAt: DateTime.fromMillisecondsSinceEpoch(json['deletedAt']),
      isEdited: json['isEdited'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'parentCommentId': parentCommentId,
      'content': content,
      'likeCount': likeCount,
      'authorId': authorId,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'isEdited': isEdited,
    };
  }

  @override
  String toString() {
    return '''CommentEntity(postId: $postId, parentCommentId: $parentCommentId, content: $content, likeCount: $likeCount, authorId: $authorId, isDeleted: $isDeleted, deletedAt: $deletedAt, isEdited: $isEdited)''';
  }

  @override
  List<Object?> get props {
    return [
      postId,
      parentCommentId,
      content,
      likeCount,
      authorId,
      isDeleted,
      deletedAt,
      isEdited,
    ];
  }
}
