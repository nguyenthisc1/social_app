import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/app/internet_connection/connection_status.dart';
import 'package:social_app/app/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:social_app/app/internet_connection/cubit/internet_connection_state.dart';
import 'package:social_app/core/theme/app_size.dart';
import 'package:social_app/core/theme/app_text_styles.dart';
import 'package:social_app/core/utils/extensions.dart';

class InternetStatusBanner extends StatefulWidget {
  const InternetStatusBanner({super.key});

  @override
  State<InternetStatusBanner> createState() => _InternetStatusBannerState();
}

class _InternetStatusBannerState extends State<InternetStatusBanner> {
  Timer? _hideTimer;
  ConnectionStatus _visibleStatus = ConnectionStatus.unknown;
  bool _isVisible = false;

  /// Prevents showing "Back online" on the very first connectivity resolve.
  bool _hasResolvedInitialState = false;

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _showBanner(ConnectionStatus status) {
    _hideTimer?.cancel();
    setState(() {
      _visibleStatus = status;
      _isVisible = true;
    });

    // "Back online" auto-dismisses after 2 s; error states stay visible.
    if (status == ConnectionStatus.connected) {
      _hideTimer = Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _isVisible = false);
      });
    }
  }

  void _hideBanner() {
    _hideTimer?.cancel();
    setState(() => _isVisible = false);
  }

  void _handleStateChange(InternetConnectionState state) {
    if (!_hasResolvedInitialState) {
      _hasResolvedInitialState = true;
      // On first resolve: show banner only if offline/slow; never show
      // "Back online" just because the app launched with connectivity.
      if (state.isDisconnected || state.isSlow) {
        _showBanner(state.status);
      }
      return;
    }

    if (state.isDisconnected) {
      _showBanner(ConnectionStatus.disconnected);
    } else if (state.isSlow) {
      _showBanner(ConnectionStatus.slow);
    } else if (state.isConnected) {
      _showBanner(ConnectionStatus.connected);
    } else {
      _hideBanner();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetConnectionCubit, InternetConnectionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) => _handleStateChange(state),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          ),
        ),
        child: !_isVisible
            ? const SizedBox.shrink(key: ValueKey('hidden'))
            : Align(
                key: ValueKey(_visibleStatus),
                alignment: Alignment.topCenter,
                child: _BannerPill(status: _visibleStatus),
              ),
      ),
    );
  }
}

class _BannerPill extends StatelessWidget {
  const _BannerPill({required this.status});

  final ConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor) = switch (status) {
      ConnectionStatus.disconnected => (
        'No Internet Connection',
        context.colorScheme.onSurface,
        Colors.white,
      ),
      ConnectionStatus.slow => (
        'Slow Internet',
        context.colorScheme.onSurface,
        Colors.white,
      ),
      ConnectionStatus.connected => (
        'Back online',
        context.colorScheme.onSurface,
        Colors.white,
      ),
      ConnectionStatus.unknown => ('', Colors.transparent, Colors.transparent),
    };

    return Container(
      margin: const EdgeInsets.only(top: AppSize.md),
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.sm,
        horizontal: AppSize.md,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSize.borderRadiusFull),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
