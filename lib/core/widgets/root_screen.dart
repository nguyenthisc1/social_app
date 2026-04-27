import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/core/services/firebase/firebase_seed_service.dart';
import 'package:social_app/core/utils/extensions.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_state.dart';

class RootScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RootScreen({super.key, required this.navigationShell});

  static const _titles = ['', 'Shop', 'Conversations', 'Search', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = navigationShell.currentIndex;
    return BlocBuilder<ConversationCubit, ConversationState>(
      builder: (context, conversationState) {
        final unreadCount = context.read<ConversationCubit>().getTotalUnreadCount(
          conversationState,
        );

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
            destinations: [
              NavigationDestination(
                icon: _buildNavIcon(theme: theme, icon: LucideIcons.house),
                selectedIcon: _buildNavIcon(
                  theme: theme,
                  icon: LucideIcons.house,
                  isSelected: true,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: _buildNavIcon(theme: theme, icon: LucideIcons.store),
                selectedIcon: _buildNavIcon(
                  theme: theme,
                  icon: LucideIcons.store,
                  isSelected: true,
                ),
                label: 'Shop',
              ),
              NavigationDestination(
                icon: _buildNavIcon(
                  theme: theme,
                  icon: LucideIcons.messageCircle,
                  badgeCount: unreadCount,
                ),
                selectedIcon: _buildNavIcon(
                  theme: theme,
                  icon: LucideIcons.messageCircle,
                  isSelected: true,
                  badgeCount: unreadCount,
                ),
                label: 'Chat',
              ),
              NavigationDestination(
                icon: _buildNavIcon(theme: theme, icon: LucideIcons.search),
                selectedIcon: _buildNavIcon(
                  theme: theme,
                  icon: LucideIcons.search,
                  isSelected: true,
                ),
                label: 'Search',
              ),
              NavigationDestination(
                icon: _buildNavIcon(theme: theme, icon: LucideIcons.user),
                selectedIcon: _buildNavIcon(
                  theme: theme,
                  icon: LucideIcons.user,
                  isSelected: true,
                ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _seedSampleData(BuildContext context) async {
    try {
      await sl<FirebaseSeedService>().seedAllIfEmpty();
      if (!context.mounted) return;
      final projectId = Firebase.app().options.projectId;
      context.showSnackBar('Seed completed on project: $projectId');
    } catch (error) {
      if (!context.mounted) return;
      context.showSnackBar('Seed failed: $error');
    }
  }

  Widget _buildNavIcon({
    required ThemeData theme,
    required IconData icon,
    bool isSelected = false,
    int badgeCount = 0,
  }) {
    final iconWidget = Icon(
      icon,
      size: AppSize.icon,
      color: isSelected ? theme.colorScheme.primary : null,
    );

    if (badgeCount <= 0) {
      return iconWidget;
    }

    final badgeLabel = badgeCount > 99 ? '99+' : '$badgeCount';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        iconWidget,
        Positioned(
          top: -6,
          right: -10,
          child: Container(
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: theme.colorScheme.error,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Center(
              child: Text(
                badgeLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onError,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
