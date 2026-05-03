import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app/core/theme/theme.dart';
import 'package:social_app/core/utils/utils.dart';
import 'package:social_app/features/conversation/application/cubit/gallery_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/gallery_state.dart';

class GalleryGridSelect extends StatefulWidget {
  const GalleryGridSelect({super.key});

  @override
  State<GalleryGridSelect> createState() => _GalleryGridSelectState();
}

class _GalleryGridSelectState extends State<GalleryGridSelect> {
  final List<String> _selectedPreviewIds = [];
  final GlobalKey<AnimatedListState> _selectedListKey =
      GlobalKey<AnimatedListState>();
  final ScrollController _selectedScrollController = ScrollController();
  final ScrollController _gridScrollController = ScrollController();

  final Map<String, Uint8List?> _thumbnailBytes = {};
  Map<String, Future<Uint8List?>> _thumbnailFutures = {};
  Map<String, AssetEntity> _imageById = {};

  @override
  void initState() {
    super.initState();
    final state = context.read<GalleryCubit>().state;
    _syncAssetCaches(state.assets);
    _selectedPreviewIds.addAll(state.selectedIds);
  }

  @override
  void dispose() {
    _gridScrollController.dispose();
    _selectedScrollController.dispose();
    super.dispose();
  }

  void _syncAssetCaches(List<AssetEntity> assets) {
    _imageById = {for (final image in assets) image.id: image};
    _thumbnailFutures = {
      for (final image in assets)
        image.id: image.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
    };
    _thumbnailBytes.removeWhere((id, _) => !_imageById.containsKey(id));
    _selectedPreviewIds.removeWhere((id) => !_imageById.containsKey(id));
    _preloadThumbnails(assets);
  }

  void _preloadThumbnails(List<AssetEntity> assets) {
    for (final image in assets) {
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

  void _syncSelectedPreviewIds(
    List<String> previousSelectedIds,
    List<String> currentSelectedIds,
  ) {
    final removedIds = previousSelectedIds
        .where((id) => !currentSelectedIds.contains(id))
        .toList();
    for (final removedId in removedIds) {
      final removeIndex = _selectedPreviewIds.indexOf(removedId);
      if (removeIndex == -1) continue;

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
      });
    }

    final insertedIds = currentSelectedIds
        .where((id) => !previousSelectedIds.contains(id))
        .toList();
    for (final insertedId in insertedIds) {
      final insertIndex = currentSelectedIds.indexOf(insertedId);
      if (_selectedPreviewIds.contains(insertedId)) continue;

      setState(() {
        _selectedPreviewIds.insert(insertIndex, insertedId);
      });

      _ensureThumbnailLoaded(insertedId);
      _selectedListKey.currentState?.insertItem(
        insertIndex,
        duration: const Duration(milliseconds: 220),
      );
    }

    if (insertedIds.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_selectedScrollController.hasClients) return;
        _selectedScrollController.animateTo(
          _selectedScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      });
    }
  }

  bool _sameIds(List<String> first, List<String> second) {
    if (first.length != second.length) return false;
    for (var i = 0; i < first.length; i++) {
      if (first[i] != second[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GalleryCubit, GalleryState>(
      listenWhen: (previous, current) =>
          previous.assets != current.assets ||
          previous.selectedIds != current.selectedIds,
      listener: (context, state) {
        final previousPreviewIds = List<String>.from(_selectedPreviewIds);
        final currentAssetIds = state.assets.map((asset) => asset.id).toList();
        final cachedAssetIds = _imageById.keys.toList();

        if (!_sameIds(cachedAssetIds, currentAssetIds)) {
          setState(() {
            _syncAssetCaches(state.assets);
          });
        }

        _syncSelectedPreviewIds(previousPreviewIds, state.selectedIds);
      },
      builder: (context, state) {
        final galleryCubit = context.read<GalleryCubit>();
        return Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 600) {
                  galleryCubit.loadMore();
                }
                return false;
              },
              child: GridView.builder(
                controller: _gridScrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: state.assets.length,
                itemBuilder: (context, index) {
                  final image = state.assets[index];
                  final id = image.id;
                  final isSelected = galleryCubit.isSelected(id);
                  final selectionNumber = galleryCubit.getSelectedIndex(id);

                  return GestureDetector(
                    onTap: () => galleryCubit.toggleSelect(id),
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
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  key: const ValueKey('selected_overlay'),
                                  color: context.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            Positioned(
                              top: AppSize.sm,
                              right: AppSize.sm,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, animation) {
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
                                        : context.colorScheme.surface
                                              .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(
                                      AppSize.borderRadiusFull,
                                    ),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Text(
                                            '$selectionNumber',
                                            style: AppTextStyles.bodyLarge
                                                .copyWith(
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
            ),
            if (state.isLoadingMore)
              const Positioned(
                bottom: 96,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            if (_selectedPreviewIds.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  top: false,
                  bottom: false,
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
                          color: context.colorScheme.surface.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 64,
                                child: AnimatedList(
                                  key: _selectedListKey,
                                  controller: _selectedScrollController,
                                  scrollDirection: Axis.horizontal,
                                  initialItemCount: _selectedPreviewIds.length,
                                  padding: const EdgeInsets.only(
                                    left: AppSize.md,
                                    right: AppSize.xxxl,
                                  ),
                                  itemBuilder: (context, index, animation) {
                                    final selectedId =
                                        _selectedPreviewIds[index];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right:
                                            index ==
                                                _selectedPreviewIds.length - 1
                                            ? 0
                                            : AppSize.sm,
                                      ),
                                      child: _SelectedPreviewItem(
                                        key: ValueKey(selectedId),
                                        thumbnailBytes:
                                            _thumbnailBytes[selectedId],
                                        onRemove: () => galleryCubit
                                            .removeSelected(selectedId),
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
                              onPressed: state.selectedIds.isEmpty
                                  ? null
                                  : () {},
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
              ),
          ],
        );
      },
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
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
