import 'package:equatable/equatable.dart';
import 'package:social_app/core/entities/author_entity.dart';
import 'package:social_app/core/utils/date_formatter.dart';

class PostModel extends Equatable {
  final String id;
  final Author author;
  final String? content;
  final List<String> images;
  final String type; // 'text', 'image', 'share'
  final String sharedPostId;
  final String visibility; // 'public', 'friends', 'private'
  final List<String> allowedUserIds;
  final int likeCount;
  final int commentCount;
  final String status; // 'active', 'hidden', 'reported'
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  const PostModel({
    required this.id,
    required this.author,
    this.content,
    this.images = const [],
    required this.type,
    this.sharedPostId = '',
    required this.visibility,
    this.allowedUserIds = const [],
    this.likeCount = 0,
    this.commentCount = 0,
    required this.status,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, [int defaultValue = 0]) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      return int.tryParse('$value') ?? defaultValue;
    }

    return PostModel(
      id: json['id'] ?? json['_id'] ?? '',
      author: Author.fromJson(json['authorId']),
      content: json['content'],
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      type: json['type'] ?? 'text',
      sharedPostId: json['sharedPostId'] != null
          ? json['sharedPostId'].toString()
          : '',
      visibility: json['visibility'] ?? 'friends',
      allowedUserIds:
          (json['allowedUserIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      likeCount: parseInt(json['likeCount']),
      commentCount: parseInt(json['commentCount']),
      status: json['status'] ?? 'active',
      isDeleted: json['isDeleted'] == true,
      createdAt: DateFormatter.parseDate(json['createdAt']),
      updatedAt: DateFormatter.parseDate(json['updatedAt']),
      v: parseInt(json['v']),
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
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
