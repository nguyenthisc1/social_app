import 'package:flutter/material.dart';
import 'package:social_app/core/theme/theme.dart';
import 'package:social_app/core/utils/utils.dart';

class ExpandedModalBottomSheet extends StatefulWidget {
  final Widget child;

  const ExpandedModalBottomSheet({super.key, required this.child});

  @override
  State<ExpandedModalBottomSheet> createState() =>
      _ExpandedModalBottomSheetState();
}

class _ExpandedModalBottomSheetState extends State<ExpandedModalBottomSheet> {
  static const double _minHeightFactor = 0.4;
  static const double _midHeightFactor = 0.5;
  static const double _maxHeightFactor = 0.9;
  static const double _expandThreshold = 0.55;
  static const double _collapseThreshold = 0.88;

  double _heightFactor = _midHeightFactor;

  bool get _isExpanded => _heightFactor > _maxHeightFactor - 0.01;

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    setState(() {
      _heightFactor -= details.primaryDelta! / screenHeight;
      _heightFactor = _heightFactor.clamp(_minHeightFactor, _maxHeightFactor);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      if (_heightFactor <= _collapseThreshold && _heightFactor > 0.7) {
        _heightFactor = _midHeightFactor;
      } else if (_heightFactor >= _expandThreshold) {
        _heightFactor = _maxHeightFactor;
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  void _handleCollapse() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: screenHeight * _heightFactor,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              _isExpanded ? AppSize.avatarSmall : AppSize.avatarSmall,
            ),
          ),
        ),
        child: Column(
          children: [
            _SheetHeader(isExpanded: _isExpanded, onCollapse: _handleCollapse),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onCollapse;

  const _SheetHeader({required this.isExpanded, required this.onCollapse});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return Container(
      height: 24,
      padding: EdgeInsets.only(top: isExpanded ? topPadding : 0),
      child: Stack(
        children: [
          // if (!isExpanded) const
          Center(child: _SheetGrabber()),
          // if (isExpanded)
          //   AppBar(
          //     title: const Text('Gallery'),
          //     leading: IconButton(
          //       icon: const Icon(Icons.arrow_back),
          //       onPressed: onCollapse,
          //     ),
          //     elevation: 0,
          //     backgroundColor: Colors.transparent,
          //     foregroundColor: Theme.of(context).colorScheme.onBackground,
          //     automaticallyImplyLeading: false,
          //   ),
        ],
      ),
    );
  }
}

class _SheetGrabber extends StatelessWidget {
  const _SheetGrabber();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: context.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(AppSize.borderRadiusSmall),
      ),
    );
  }
}
