import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app/features/conversation/application/cubit/gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit() : super(GalleryState.initial());

  AssetPathEntity? _recentAlbum;

  Future<void> initialize() async {
    if (state.isLoading || state.assets.isNotEmpty) return;
    await requestPermissionAndLoad();
  }

  Future<void> requestPermissionAndLoad() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final permissionState = await PhotoManager.requestPermissionExtend();
      if (!permissionState.isAuth) {
        emit(
          state.copyWith(
            isLoading: false,
            hasPermission: false,
            hasMore: false,
            assets: const [],
            clearError: true,
          ),
        );
        return;
      }

      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      if (albums.isEmpty) {
        _recentAlbum = null;
        emit(
          state.copyWith(
            isLoading: false,
            hasPermission: true,
            hasMore: false,
            assets: const [],
            page: 0,
            clearError: true,
          ),
        );
        return;
      }

      _recentAlbum = albums.first;
      await loadInitial();
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          hasPermission: false,
          hasMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> loadInitial() async {
    final album = _recentAlbum;
    if (album == null) {
      emit(state.copyWith(isLoading: false, hasMore: false));
      return;
    }

    emit(state.copyWith(isLoading: true, page: 0, clearError: true));

    try {
      final assets = await album.getAssetListPaged(
        page: 0,
        size: state.pageSize,
      );

      emit(
        state.copyWith(
          assets: assets,
          page: 0,
          isLoading: false,
          hasPermission: true,
          hasMore: assets.length == state.pageSize,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
          hasPermission: true,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final album = _recentAlbum;
    if (album == null ||
        state.isLoading ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    try {
      final nextPage = state.page + 1;
      final nextAssets = await album.getAssetListPaged(
        page: nextPage,
        size: state.pageSize,
      );

      final mergedAssets = [
        ...state.assets,
        ...nextAssets.where(
          (asset) => state.assets.every((existing) => existing.id != asset.id),
        ),
      ];

      emit(
        state.copyWith(
          assets: mergedAssets,
          page: nextPage,
          isLoadingMore: false,
          hasMore: nextAssets.length == state.pageSize,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isLoadingMore: false, errorMessage: error.toString()),
      );
    }
  }

  Future<void> refresh() async {
    await requestPermissionAndLoad();
  }

  void toggleSelect(String assetId) {
    final updatedSelectedIds = List<String>.from(state.selectedIds);

    if (updatedSelectedIds.contains(assetId)) {
      updatedSelectedIds.remove(assetId);
    } else {
      updatedSelectedIds.add(assetId);
    }

    emit(state.copyWith(selectedIds: updatedSelectedIds));
  }

  void clearSelection() {
    emit(state.copyWith(selectedIds: const []));
  }

  void removeSelected(String assetId) {
    if (!state.selectedIds.contains(assetId)) return;

    final updatedSelectedIds = List<String>.from(state.selectedIds)
      ..remove(assetId);
    emit(state.copyWith(selectedIds: updatedSelectedIds));
  }

  bool isSelected(String assetId) {
    return state.selectedIds.contains(assetId);
  }

  int getSelectedIndex(String assetId) {
    final index = state.selectedIds.indexOf(assetId);
    return index == -1 ? 0 : index + 1;
  }

  List<AssetEntity> getSelectedAssets() {
    final imageById = {for (final asset in state.assets) asset.id: asset};

    return state.selectedIds
        .map((id) => imageById[id])
        .whereType<AssetEntity>()
        .toList();
  }

  void reset() {
    _recentAlbum = null;
    emit(GalleryState.initial());
  }
}
