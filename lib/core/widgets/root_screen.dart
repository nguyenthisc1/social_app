import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/core/services/firebase/firebase_seed_service.dart';
import 'package:social_app/core/utils/extensions.dart';

class RootScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RootScreen({super.key, required this.navigationShell});

  static const _titles = ['', 'Shop', 'Conversations', 'Search', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = navigationShell.currentIndex;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        title: index == 0
            ? Text(
                'Social',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              )
            : Text(
                _titles[index],
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
        leading: IconButton(
          icon: const Icon(LucideIcons.plus, size: AppSize.icon),
          onPressed: () => context.push(AppRoutes.createPost),
        ),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(LucideIcons.databaseZap, size: AppSize.icon),
              tooltip: 'Seed sample chat data',
              onPressed: () => _seedSampleData(context),
            ),
          IconButton(
            icon: const Icon(LucideIcons.heart, size: AppSize.icon),
            onPressed: () {},
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          navigationShell.goBranch(
            i,
            initialLocation: i == navigationShell.currentIndex,
          );
        },
        elevation: 0,
        height: 60,
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        // Remove const, because we use non-const value (theme) in selectedIcon
        destinations: [
          NavigationDestination(
            icon: Icon(LucideIcons.house, size: AppSize.icon),
            selectedIcon: Icon(
              LucideIcons.house,
              size: AppSize.icon,
              color: theme.colorScheme.primary,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.store, size: AppSize.icon),
            selectedIcon: Icon(
              LucideIcons.store,
              size: AppSize.icon,
              color: theme.colorScheme.primary,
            ),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.messageCircle, size: AppSize.icon),
            selectedIcon: Icon(
              LucideIcons.messageCircle,
              size: AppSize.icon,
              color: theme.colorScheme.primary,
            ),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.search, size: AppSize.icon),
            selectedIcon: Icon(
              LucideIcons.search,
              size: AppSize.icon,
              color: theme.colorScheme.primary,
            ),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.user, size: AppSize.icon),
            selectedIcon: Icon(
              LucideIcons.user,
              size: AppSize.icon,
              color: theme.colorScheme.primary,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Future<void> _seedSampleData(BuildContext context) async {
    try {
      await sl<FirebaseSeedService>().seedAllIfEmpty();
      final projectId = Firebase.app().options.projectId;
      // ignore: use_build_context_synchronously
      context.showSnackBar('Seed completed on project: $projectId');
    } catch (error) {
      context.showSnackBar('Seed failed: $error');
    }
  }
}
