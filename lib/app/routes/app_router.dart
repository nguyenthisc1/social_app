import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_detail_cubit.dart';
import 'package:social_app/features/message/application/cubit/meesage_cubit.dart';
import 'package:social_app/presentations/conversation/pages/conversation_detail_page.dart';
import 'package:social_app/presentations/post/screens/create_post_screen.dart';

import '../../features/auth/application/bloc/auth_bloc.dart';
import '../../presentations/auth/pages/login_screen.dart';
import '../../presentations/auth/pages/register_screen.dart';
import '../../presentations/auth/pages/splash_screen.dart';
import '../../presentations/conversation/pages/conversations_page.dart';
import '../../presentations/home/pages/home_page.dart';
import '../../presentations/profile/pages/profile_page.dart';
import '../../presentations/search/pages/search_page.dart';
import '../../presentations/shop/pages/shop_page.dart';
import '../di/injection_container.dart';
import '../../core/widgets/root_screen.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    redirect: _redirect,
    refreshListenable: _AuthStateNotifier(),
    routes: [
      // ====================================================================
      // Splash
      // ====================================================================
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // ====================================================================
      // Auth Routes (no shell)
      // ====================================================================
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
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Forgot Password'),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Reset Password'),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        name: 'verifyEmail',
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Verify Email'),
      ),

      // ====================================================================
      // Main App Shell (protected — 5-tab layout)
      // ====================================================================
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) {
          return RootScreen(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0 — Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),

          // Tab 1 — Shop
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.shop,
                name: 'shop',
                builder: (context, state) => const ShopPage(),
              ),
            ],
          ),

          // Tab 2 — Conversations
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.conversations,
                name: 'conversations',
                builder: (context, state) => const ConversationsPage(),
              ),
            ],
          ),

          // Tab 3 — Search
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                name: 'search',
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),

          // Tab 4 — Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // ====================================================================
      // Detail Routes (pushed on top of shell — no bottom nav)
      // ====================================================================
      GoRoute(
        path: AppRoutes.createPost,
        name: 'createPost',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreatePostScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.postDetail}/:id',
        name: 'postDetail',
        parentNavigatorKey: _rootNavigatorKey,
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
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final postId = state.pathParameters['id']!;
          return _PlaceholderScreen(
            title: 'Edit Post',
            subtitle: 'Post ID: $postId',
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.userProfile}/:id',
        name: 'userProfile',
        parentNavigatorKey: _rootNavigatorKey,
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
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Edit Profile'),
      ),
      GoRoute(
        path: '${AppRoutes.followers}/:id',
        name: 'followers',
        parentNavigatorKey: _rootNavigatorKey,
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
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return _PlaceholderScreen(
            title: 'Following',
            subtitle: 'User ID: $userId',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Settings'),
        routes: [
          GoRoute(
            path: 'account',
            name: 'accountSettings',
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Account Settings'),
          ),
          GoRoute(
            path: 'privacy',
            name: 'privacySettings',
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Privacy Settings'),
          ),
          GoRoute(
            path: 'notifications',
            name: 'notificationSettings',
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Notification Settings'),
          ),
          GoRoute(
            path: 'theme',
            name: 'themeSettings',
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Theme Settings'),
          ),
          GoRoute(
            path: 'about',
            name: 'about',
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'About'),
          ),
        ],
      ),
      GoRoute(
        path: '${AppRoutes.chat}/:id',
        name: 'chat',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final conversationId = state.pathParameters['id']!;

          return MultiBlocProvider(
            providers: [
              BlocProvider<ConversationDetailCubit>(
                create: (context) =>
                    sl<ConversationDetailCubit>()
                      ..getConversation(conversationId),
              ),
              BlocProvider<MessageCubit>(
                create: (context) =>
                    sl<MessageCubit>()..watchMessages(conversationId),
              ),
            ],
            child: ConversationDetailPage(conversationId: conversationId),
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
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Page Not Found',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

  static String? _redirect(BuildContext context, GoRouterState state) {
    final authBloc = sl<AuthBloc>();
    final authState = authBloc.state;
    final location = state.matchedLocation;
    final isOnSplash = location == AppRoutes.splash;
    final isOnAuthRoute =
        location == AppRoutes.login ||
        location == AppRoutes.register ||
        location == AppRoutes.forgotPassword ||
        location == AppRoutes.resetPassword ||
        location == AppRoutes.verifyEmail;

    final isAuthenticated = authState is AuthAuthenticated;
    final isLoading = authState is AuthInitial || authState is AuthLoading;

    // Auth state still loading — stay on or go to splash
    if (isLoading) {
      return isOnSplash ? null : AppRoutes.splash;
    }

    // Auth resolved — redirect away from splash
    if (isOnSplash) {
      return isAuthenticated ? AppRoutes.home : AppRoutes.login;
    }

    // Not authenticated — only allow auth routes
    if (!isAuthenticated && !isOnAuthRoute) {
      return AppRoutes.login;
    }

    // Authenticated — don't allow auth routes
    if (isAuthenticated && isOnAuthRoute) {
      return AppRoutes.home;
    }

    return null;
  }
}

class _AuthStateNotifier extends ChangeNotifier {
  late final Stream<AuthState> _stream;

  _AuthStateNotifier() {
    final authBloc = sl<AuthBloc>();
    _stream = authBloc.stream;
    _stream
        .where(
          (state) => state is AuthAuthenticated || state is AuthUnauthenticated,
        )
        .listen((_) {
          notifyListeners();
        });
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _PlaceholderScreen({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.construction, size: 64, color: Colors.orange),
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
