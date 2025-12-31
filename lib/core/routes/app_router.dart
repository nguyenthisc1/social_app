import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/home_screen.dart';
import '../di/injection_container.dart';
import 'app_routes.dart';

/// GoRouter configuration for the app
class AppRouter {
  AppRouter._();

  /// Router instance
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    redirect: _redirect,
    refreshListenable: _AuthStateNotifier(),
    routes: [
      // ========================================================================
      // Initial Route
      // ========================================================================
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // ========================================================================
      // Auth Routes
      // ========================================================================
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Forgot Password',
        ),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Reset Password',
        ),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        name: 'verifyEmail',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Verify Email',
        ),
      ),

      // ========================================================================
      // Main App Routes (Protected)
      // ========================================================================
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.feed,
        name: 'feed',
        builder: (context, state) => const _PlaceholderScreen(title: 'Feed'),
      ),
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) => const _PlaceholderScreen(title: 'Search'),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Notifications',
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
      ),

      // ========================================================================
      // Post Routes
      // ========================================================================
      GoRoute(
        path: AppRoutes.createPost,
        name: 'createPost',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Create Post',
        ),
      ),
      GoRoute(
        path: '${AppRoutes.postDetail}/:id',
        name: 'postDetail',
        builder: (context, state) {
          final postId = state.pathParameters['id']!;
          return _PlaceholderScreen(
            title: 'Post Detail',
            subtitle: 'Post ID: $postId',
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.editPost}/:id',
        name: 'editPost',
        builder: (context, state) {
          final postId = state.pathParameters['id']!;
          return _PlaceholderScreen(
            title: 'Edit Post',
            subtitle: 'Post ID: $postId',
          );
        },
      ),

      // ========================================================================
      // User Routes
      // ========================================================================
      GoRoute(
        path: '${AppRoutes.userProfile}/:id',
        name: 'userProfile',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return _PlaceholderScreen(
            title: 'User Profile',
            subtitle: 'User ID: $userId',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Edit Profile',
        ),
      ),
      GoRoute(
        path: '${AppRoutes.followers}/:id',
        name: 'followers',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return _PlaceholderScreen(
            title: 'Followers',
            subtitle: 'User ID: $userId',
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.following}/:id',
        name: 'following',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return _PlaceholderScreen(
            title: 'Following',
            subtitle: 'User ID: $userId',
          );
        },
      ),

      // ========================================================================
      // Settings Routes
      // ========================================================================
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Settings',
        ),
        routes: [
          GoRoute(
            path: 'account',
            name: 'accountSettings',
            builder: (context, state) => const _PlaceholderScreen(
              title: 'Account Settings',
            ),
          ),
          GoRoute(
            path: 'privacy',
            name: 'privacySettings',
            builder: (context, state) => const _PlaceholderScreen(
              title: 'Privacy Settings',
            ),
          ),
          GoRoute(
            path: 'notifications',
            name: 'notificationSettings',
            builder: (context, state) => const _PlaceholderScreen(
              title: 'Notification Settings',
            ),
          ),
          GoRoute(
            path: 'theme',
            name: 'themeSettings',
            builder: (context, state) => const _PlaceholderScreen(
              title: 'Theme Settings',
            ),
          ),
          GoRoute(
            path: 'about',
            name: 'about',
            builder: (context, state) => const _PlaceholderScreen(
              title: 'About',
            ),
          ),
        ],
      ),

      // ========================================================================
      // Chat/Messages Routes
      // ========================================================================
      GoRoute(
        path: AppRoutes.messages,
        name: 'messages',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Messages',
        ),
      ),
      GoRoute(
        path: '${AppRoutes.chat}/:id',
        name: 'chat',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return _PlaceholderScreen(
            title: 'Chat',
            subtitle: 'User ID: $userId',
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Page Not Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Path: ${state.uri.path}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  /// Redirect logic for route guards
  static String? _redirect(BuildContext context, GoRouterState state) {
    final authBloc = sl<AuthBloc>();
    final isAuthenticated = authBloc.state is AuthAuthenticated;
    final isOnSplash = state.matchedLocation == AppRoutes.splash;
    final isOnAuthRoute = state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register ||
        state.matchedLocation == AppRoutes.forgotPassword ||
        state.matchedLocation == AppRoutes.resetPassword ||
        state.matchedLocation == AppRoutes.verifyEmail;

    // Allow splash screen
    if (isOnSplash) {
      return null;
    }

    // Redirect to login if not authenticated and trying to access protected route
    if (!isAuthenticated && !isOnAuthRoute) {
      return AppRoutes.login;
    }

    // Redirect to home if authenticated and trying to access auth routes
    if (isAuthenticated && isOnAuthRoute) {
      return AppRoutes.home;
    }

    // No redirect needed
    return null;
  }
}

/// Notifier for auth state changes to trigger route refresh
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier() {
    final authBloc = sl<AuthBloc>();
    authBloc.stream.listen((_) {
      notifyListeners();
    });
  }
}

/// Placeholder screen for routes not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _PlaceholderScreen({
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.construction,
                size: 64,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'This screen is under construction',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

