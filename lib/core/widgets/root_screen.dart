import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
          icon: const Icon(LucideIcons.squarePlus, size: 24),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.heart, size: 24),
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
        destinations: const [
          NavigationDestination(
            icon: Icon(LucideIcons.house, size: 26),
            selectedIcon: Icon(LucideIcons.house, size: 26),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.store, size: 26),
            selectedIcon: Icon(LucideIcons.store, size: 26),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.messageCircle, size: 24),
            selectedIcon: Icon(LucideIcons.messageCircle, size: 24),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.search, size: 26),
            selectedIcon: Icon(LucideIcons.search, size: 26),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.user, size: 26),
            selectedIcon: Icon(LucideIcons.user, size: 26),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
