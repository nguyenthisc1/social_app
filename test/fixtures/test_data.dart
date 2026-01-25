import 'package:social_app/core/entities/author_entity.dart';
import 'package:social_app/features/auth/domain/entities/auth_tokens.dart';
import 'package:social_app/features/auth/domain/entities/user.dart';
import 'package:social_app/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_enums.dart';
import 'package:social_app/features/post/domain/entities/post_entity.dart';
import 'package:social_app/features/post/domain/entities/post_enum.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_entity.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';

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

  // Reaction Test Data
  static final testReaction = ReactionEntity(
    id: 'reaction123',
    userId: 'user123',
    targetType: ReactionTargetType.post,
    targetId: 'post123',
    type: ReactionType.like,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static const testReactionResponse = ReactionResponseEntity(
    action: ReactionAction.created,
  );

  static const testReactionSummary = [
    ReactionSummaryEntity(type: ReactionType.like, count: 10),
    ReactionSummaryEntity(type: ReactionType.love, count: 5),
    ReactionSummaryEntity(type: ReactionType.haha, count: 3),
  ];

  // Friendship Test Data
  static final testFriendship = FriendshipEntity(
    id: 'friendship123',
    requesterId: 'user123',
    receiverId: 'user456',
    status: FriendshipStatus.pending,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final testFriendRequest = FriendRequestEntity(
    id: 'friendship123',
    requesterId: 'user123',
    receiverId: 'user456',
    status: FriendshipStatus.pending,
    username: 'frienduser',
    email: 'friend@example.com',
    avatarUrl: 'https://example.com/friend-avatar.jpg',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static const testFriendshipResponse = FriendshipResponseEntity(
    success: true,
    message: 'Friend request sent successfully',
  );

  static const testFriend = FriendEntity(
    id: 'friend123',
    username: 'frienduser',
    email: 'friend@example.com',
    avatarUrl: 'https://example.com/friend-avatar.jpg',
    bio: 'Friend bio',
  );

  static const testFriendsList = [
    testFriend,
    FriendEntity(
      id: 'friend456',
      username: 'anotherfriend',
      email: 'another@example.com',
    ),
  ];

  static const testFriendshipStatus = FriendshipStatusEntity(
    isFriend: true,
    message: 'Users are friends',
  );
}
