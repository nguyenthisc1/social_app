import 'package:social_app/features/post/domain/entites/post_enum.dart';

extension PostTypeMapper on String {
  PostType toPostType() {
    switch (this) {
      case 'image':
        return PostType.image;
      case 'video':
        return PostType.video;
      default:
        return PostType.text;
    }
  }
}

extension PostVisibilityMapper on String {
  PostVisibility toPostVisibility() {
    switch (this) {
      case 'friends':
        return PostVisibility.friends;
      case 'private':
        return PostVisibility.private;
      default:
        return PostVisibility.public;
    }
  }
}

extension PostStatusMapper on String {
  PostStatus toPostStatus() {
    switch (this) {
      case 'active':
        return PostStatus.active;
      case 'hidden':
        return PostStatus.hidden;
      default:
        return PostStatus.reported;
    }
  }
}

extension PostTypeToString on PostType {
  String get value {
    switch (this) {
      case PostType.image:
        return 'image';
      case PostType.video:
        return 'video';
      case PostType.text:
      default:
        return 'text';
    }
  }
}

extension PostVisibilityToString on PostVisibility {
  String get value {
    switch (this) {
      case PostVisibility.friends:
        return 'friends';
      case PostVisibility.private:
        return 'private';
      case PostVisibility.public:
      default:
        return 'public';
    }
  }
}

extension PostStatusToString on PostStatus {
  String get value {
    switch (this) {
      case PostStatus.active:
        return 'active';
      case PostStatus.hidden:
        return 'hidden';
      case PostStatus.reported:
      default:
        return 'reported';
    }
  }
}
