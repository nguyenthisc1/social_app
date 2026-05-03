import 'package:photo_manager/photo_manager.dart';

class GalleryState {
  final List<AssetEntity> assets;
  final List<String> selectedIds;
  final int page;
  final int pageSize;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final bool hasPermission;
  final String? errorMessage;

  factory GalleryState.initial() {
    return const GalleryState(
      assets: [],
      selectedIds: [],
      page: 0,
      pageSize: 100,
      isLoading: false,
      isLoadingMore: false,
      hasMore: false,
      hasPermission: false,
      errorMessage: null,
    );
  }

  const GalleryState({
    required this.assets,
    required this.selectedIds,
    required this.page,
    required this.pageSize,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.hasPermission,
    this.errorMessage,
  });

  GalleryState copyWith({
    List<AssetEntity>? assets,
    List<String>? selectedIds,
    int? page,
    int? pageSize,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    bool? hasPermission,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GalleryState(
      assets: assets ?? this.assets,
      selectedIds: selectedIds ?? this.selectedIds,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      hasPermission: hasPermission ?? this.hasPermission,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
