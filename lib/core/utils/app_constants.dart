/// Application-wide constants
class AppConstants {
  AppConstants._();

  static const String apiBaseUrl = 'http://172.16.16.102:8080';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  static const Duration cacheExpiry = Duration(hours: 24);
  static const Duration shortCacheExpiry = Duration(minutes: 5);

  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxUsernameLength = 30;
  static const int maxBioLength = 500;
  static const int maxPostLength = 5000;

  static const int maxImageSizeMB = 10;
  static const int maxVideoSizeMB = 100;
  static const List<String> allowedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  ];
  static const List<String> allowedVideoFormats = ['mp4', 'mov', 'avi'];

  static const int maxHashtagsPerPost = 30;
  static const int maxMentionsPerPost = 20;
}

class ScreenUtilSize {
  const ScreenUtilSize._();
  static const double width = 390;
  static const double height = 844;
}

/// API endpoints
class ApiEndpoints {
  ApiEndpoints._();

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String getUserById = '/user';
  static const String followUser = '/user';
  static const String unfollowUser = '/user';
  static const String followers = '/user';
  static const String following = '/user';

  static const String posts = '/post';
  static const String createPost = '/post';
  static const String getPost = '/post';
  static const String updatePost = '/post';
  static const String softdeletePost = '/post/delete';
  static const String likePost = '/post';
  static const String unlikePost = '/post';
  static const String feedHome = '/post/feed/home';
  static const String postsByUser = '/post/user';

  static const String comments = '/comment';
  static const String createComment = '/comment';
  static const String getComment = '/comment';
  static const String updateComment = '/comment';
  static const String deleteComment = '/comment';

  static const String notifications = '/notification';
  static const String markAsRead = '/notification';
  static const String markAllAsRead = '/notification/read-all';

  static const String react = '/reactions/react';
  static const String reactsummary = '/reactions/summary';
  static const String userReaction = '/reactions/user-reaction';

  static const String sendFriendRequest = '/friendship/request';
  static const String acceptFriendRequest = '/friendship/accept';
  static const String rejectFriendRequest = '/friendship/reject';
  static const String pendingRequests = '/friendship/requests/pending';
  static const String sentRequests = '/friendship/requests/sent';
  static const String friends = '/friendship/friends';
  static const String userFriends = '/friendship/friends';
  static const String checkFriendship = '/friendship/is-friend';
  static const String friendIds = '/friendship/friend-ids';
}
