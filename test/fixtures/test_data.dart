import 'package:social_app/core/entities/author_entity.dart';
import 'package:social_app/features/auth/domain/entities/auth_tokens.dart';
import 'package:social_app/features/auth/domain/entities/user.dart';
import 'package:social_app/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app/features/post/domain/entities/post_entity.dart';
import 'package:social_app/features/post/domain/entities/post_enum.dart';

/// Test fixture data for unit tests
class TestData {
  TestData._();

  // User Test Data
  static final testUser = User(
    id: 'user123',
    username: 'testuser',
    email: 'test@example.com',
    avatarUrl: 'https://example.com/avatar.jpg',
    bio: 'Test bio',
    friends: const ['friend1', 'friend2'],
    following: const ['user1', 'user2'],
    followers: const ['follower1', 'follower2'],
    isActive: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  // Auth Tokens Test Data
  static final testAuthTokens = AuthTokens(
    accessToken: 'test_access_token',
    refreshToken: 'test_refresh_token',
    expiresAt: DateTime.now().add(const Duration(hours: 1)),
  );

  // Author Test Data
  static const testAuthor = Author(
    id: 'author123',
    username: 'testauthor',
  );

  // Post Test Data
  static final testPost = PostEntity(
    id: 'post123',
    author: testAuthor,
    content: 'Test post content',
    images: const ['https://example.com/image1.jpg'],
    type: PostType.text,
    sharedPostId: null,
    visibility: PostVisibility.public,
    allowedUserIds: const [],
    likeCount: 10,
    commentCount: 5,
    status: PostStatus.active,
    isDeleted: false,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
    v: 0,
  );

  static final testPostList = [
    testPost,
    testPost.copyWith(
      id: 'post456',
      content: 'Second test post',
      likeCount: 20,
    ),
  ];

  // Comment Test Data
  static const testComment = CommentEntity(
    postId: 'post123',
    parentCommentId: null,
    content: 'Test comment',
    likeCount: 3,
    authorId: 'user123',
    isDeleted: false,
    isEdited: false,
  );

  static const testReply = CommentEntity(
    postId: 'post123',
    parentCommentId: 'comment123',
    content: 'Test reply',
    likeCount: 1,
    authorId: 'user456',
    isDeleted: false,
    isEdited: false,
  );

  static const testCommentList = [
    testComment,
    CommentEntity(
      postId: 'post123',
      content: 'Another test comment',
      likeCount: 5,
      authorId: 'user789',
    ),
  ];
}
