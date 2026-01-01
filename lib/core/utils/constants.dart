/// Application-wide constants
class AppConstants {
  AppConstants._();

  // API Configuration
  static const String apiBaseUrl = 'https://api.example.com/v1';
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Duration
  static const Duration cacheExpiry = Duration(hours: 24);
  static const Duration shortCacheExpiry = Duration(minutes: 5);

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxUsernameLength = 30;
  static const int maxBioLength = 500;
  static const int maxPostLength = 5000;

  // Media
  static const int maxImageSizeMB = 10;
  static const int maxVideoSizeMB = 100;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> allowedVideoFormats = ['mp4', 'mov', 'avi'];

  // Social Features
  static const int maxHashtagsPerPost = 30;
  static const int maxMentionsPerPost = 20;
}

/// API endpoints
class ApiEndpoints {
  ApiEndpoints._();

  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String getUserById = '/user'; // + /{id}
  static const String followUser = '/user'; // + /{id}/follow
  static const String unfollowUser = '/user'; // + /{id}/unfollow
  static const String followers = '/user'; // + /{id}/followers
  static const String following = '/user'; // + /{id}/following

  // Posts
  static const String posts = '/post';
  static const String createPost = '/post';
  static const String getPost = '/post'; // + /{id}
  static const String updatePost = '/post'; // + /{id}
  static const String softdeletePost = '/post/delete'; // + /{id}
  static const String likePost = '/post'; // + /{id}/like
  static const String unlikePost = '/post'; // + /{id}/unlike
  static const String feedHome = '/post/feed/home';
  static const String postsByUser = '/post/user'; // + "viewerId"

  // Comments
  static const String comments = '/comment';
  static const String createComment = '/comment';
  static const String getComment = '/comment'; // + /{id}
  static const String updateComment = '/comment'; // + /{id}
  static const String deleteComment = '/comment'; // + /{id}

  // Notifications
  static const String notifications = '/notification';
  static const String markAsRead = '/notification'; // + /{id}/read
  static const String markAllAsRead = '/notification/read-all';
}

