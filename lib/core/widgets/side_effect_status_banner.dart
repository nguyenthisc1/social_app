import 'package:flutter/material.dart';
import 'package:social_app/core/utils/utils.dart';

class SideEffectStatusBanner extends StatefulWidget {
  const SideEffectStatusBanner({
    super.key,
    required this.text,
    this.show = true,
  });

  final String text;
  final bool show;

  @override
  State<SideEffectStatusBanner> createState() =>
      SideEffectStatusBannerState();
}

class SideEffectStatusBannerState extends State<SideEffectStatusBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  static const _bannerHeight = 48.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    if (widget.show) {
      _controller.forward();
    } else {
      _controller.value = 0.0;
    }
  }

  @override
  void didUpdateWidget(SideEffectStatusBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show) {
      if (widget.show) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.vertical,
      axisAlignment: -1, // Animate from the top
      child: Container(
        width: double.infinity,
        height: _bannerHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: context.colorScheme.surfaceVariant,
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.text,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
