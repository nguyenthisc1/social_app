/// Route names for the application
class AppRoutes {
  AppRoutes._();

  // Initial routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';

  // Main app routes
  static const String home = '/home';
  static const String feed = '/feed';
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  // Post routes
  static const String createPost = '/create-post';
  static const String postDetail = '/post-detail';
  static const String editPost = '/edit-post';

  // User routes
  static const String userProfile = '/user-profile';
  static const String editProfile = '/edit-profile';
  static const String followers = '/followers';
  static const String following = '/following';

  // Settings routes
  static const String settings = '/settings';
  static const String accountSettings = '/settings/account';
  static const String privacySettings = '/settings/privacy';
  static const String notificationSettings = '/settings/notifications';
  static const String themeSettings = '/settings/theme';
  static const String about = '/settings/about';

  // Chat/Messages routes
  static const String messages = '/messages';
  static const String chat = '/chat';

  // Other routes
  static const String error = '/error';
}

