import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app/core/theme/theme.dart';
import 'package:social_app/core/utils/utils.dart';

class GalleryGridSelect extends StatefulWidget {
  final List<AssetEntity> images;
  final ValueChanged<List<AssetEntity>>? onSelectionChanged;

  const GalleryGridSelect({
    super.key,
    required this.images,
    this.onSelectionChanged,
  });

  @override
  State<GalleryGridSelect> createState() => _GalleryGridSelectState();
}

class _GalleryGridSelectState extends State<GalleryGridSelect> {
  final List<String> selectedIds = [];
  final List<String> _selectedPreviewIds = [];
  final GlobalKey<AnimatedListState> _selectedListKey =
      GlobalKey<AnimatedListState>();
  late Map<String, Future<Uint8List?>> _thumbnailFutures;
  final Map<String, Uint8List?> _thumbnailBytes = {};
  late Map<String, AssetEntity> _imageById;
  final ScrollController _selectedScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _buildImageCaches();
    _preloadThumbnails();
  }

  @override
  void didUpdateWidget(covariant GalleryGridSelect oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.images != widget.images) {
      _buildImageCaches();
      _thumbnailBytes.clear();
      selectedIds.removeWhere((id) => !_imageById.containsKey(id));
      _selectedPreviewIds.removeWhere((id) => !_imageById.containsKey(id));
      _preloadThumbnails();
      _notifySelectionChanged();
    }
  }

  void _buildImageCaches() {
    _imageById = {for (final image in widget.images) image.id: image};
    _thumbnailFutures = {
      for (final image in widget.images)
        image.id: image.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
    };
  }

  void _preloadThumbnails() {
    for (final image in widget.images) {
      _ensureThumbnailLoaded(image.id);
    }
  }

  Future<void> _ensureThumbnailLoaded(String id) async {
    if (_thumbnailBytes.containsKey(id)) return;

    final bytes = await _thumbnailFutures[id];
    if (!mounted) return;

    setState(() {
      _thumbnailBytes[id] = bytes;
    });
  }

  @override
  void dispose() {
    _selectedScrollController.dispose();
    super.dispose();
  }

  void _notifySelectionChanged() {
    if (widget.onSelectionChanged == null) return;

    final selectedImages = selectedIds
        .map((id) => _imageById[id])
        .whereType<AssetEntity>()
        .toList();

    widget.onSelectionChanged!(selectedImages);
  }

  void onToggleSelect(String id) {
    final wasSelected = selectedIds.contains(id);

    if (wasSelected) {
      final removeIndex = _selectedPreviewIds.indexOf(id);
      if (removeIndex == -1) return;

      final removedId = _selectedPreviewIds[removeIndex];
      final removedBytes = _thumbnailBytes[removedId];

      _selectedListKey.currentState?.removeItem(
        removeIndex,
        (context, animation) => _SelectedPreviewItem(
          key: ValueKey('removed_$removedId'),
          thumbnailBytes: removedBytes,
          onRemove: () {},
          animation: animation,
        ),
        duration: const Duration(milliseconds: 220),
      );

      setState(() {
        _selectedPreviewIds.removeAt(removeIndex);
        selectedIds.remove(id);
      });

      _notifySelectionChanged();

      return;
    }

    final insertIndex = _selectedPreviewIds.length;

    setState(() {
      selectedIds.add(id);
      _selectedPreviewIds.add(id);
    });

    _notifySelectionChanged();

    _ensureThumbnailLoaded(id);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectedListKey.currentState?.insertItem(
        insertIndex,
        duration: const Duration(milliseconds: 220),
      );

      if (!_selectedScrollController.hasClients) return;

      _selectedScrollController.animateTo(
        _selectedScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  int getImageSelectedIndex(String id) {
    final idx = selectedIds.indexOf(id);
    return idx == -1 ? 0 : idx + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            if (index < 0 || index >= widget.images.length) {
              // Added guard for index out of range
              return const SizedBox.shrink();
            }
            final image = widget.images[index];
            final id = image.id;
            final isSelected = selectedIds.contains(id);
            final selectionNumber = getImageSelectedIndex(id);

            return GestureDetector(
              onTap: () => onToggleSelect(id),
              child: FutureBuilder<Uint8List?>(
                future: _thumbnailFutures[id],
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                      if (isSelected)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          child: isSelected
                              ? Container(
                                  key: const ValueKey('selected_overlay'),
                                  color: context.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('unselected_overlay'),
                                ),
                        ),
                      Positioned(
                        top: AppSize.sm,
                        right: AppSize.sm,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          child: Container(
                            key: ValueKey(isSelected),
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : context.colorScheme.surface.withValues(
                                      alpha: 0.5,
                                    ),
                              borderRadius: BorderRadius.circular(
                                AppSize.borderRadiusFull,
                              ),
                              border: Border.all(color: Colors.white),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Text(
                                      '$selectionNumber',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
        if (_selectedPreviewIds.isNotEmpty)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Container(
                  padding: const EdgeInsets.only(
                    top: AppSize.md,
                    right: AppSize.md,
                    bottom: AppSize.xxl,
                  ),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface.withValues(alpha: 0.8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 64,
                          child: AnimatedList(
                            shrinkWrap: true,
                            key: _selectedListKey,
                            controller: _selectedScrollController,
                            scrollDirection: Axis.horizontal,
                            initialItemCount: _selectedPreviewIds.length,
                            padding: const EdgeInsets.only(
                              left: AppSize.md,
                              right: 0,
                            ),
                            itemBuilder: (context, index, animation) {
                              if (index < 0 ||
                                  index >= _selectedPreviewIds.length) {
                                // Added guard for index out of range
                                return const SizedBox.shrink();
                              }
                              final selectedId = _selectedPreviewIds[index];
                              if (!_imageById.containsKey(selectedId)) {
                                return const SizedBox.shrink();
                              }

                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index == _selectedPreviewIds.length - 1
                                      ? 0
                                      : AppSize.sm,
                                ),
                                child: _SelectedPreviewItem(
                                  thumbnailBytes: _thumbnailBytes[selectedId],
                                  onRemove: () => onToggleSelect(selectedId),
                                  animation: animation,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSize.md),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.primary,
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              LucideIcons.sendHorizontal,
                              color: Colors.white,
                            ),
                            const SizedBox(width: AppSize.sm),
                            Text(
                              'Send',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SelectedPreviewItem extends StatelessWidget {
  const _SelectedPreviewItem({
    super.key,
    required this.thumbnailBytes,
    required this.onRemove,
    required this.animation,
  });

  final Uint8List? thumbnailBytes;
  final VoidCallback onRemove;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );

    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.horizontal,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
        child: Stack(
          children: [
            if (thumbnailBytes == null)
              const SizedBox(width: 40, height: 64)
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.md),
                child: Image.memory(
                  thumbnailBytes!,
                  width: 40,
                  height: 64,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              ),
            // Positioned(
            //   top: 4,
            //   right: 4,
            //   child: GestureDetector(
            //     onTap: onRemove,
            //     child: Container(
            //       width: 16,
            //       height: 16,
            //       decoration: const BoxDecoration(
            //         color: Colors.black54,
            //         shape: BoxShape.circle,
            //       ),
            //       child: const Icon(
            //         Icons.close,
            //         size: 12,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
