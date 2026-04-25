import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/user/application/cubit/user_state.dart';
import 'package:social_app/features/user/data/datasources/local/user_local_data_source.dart';
import 'package:social_app/features/user/data/mappers/user_mapper.dart';
import 'package:social_app/features/user/domain/entites/user_entity.dart';
import 'package:social_app/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:social_app/features/user/domain/usecases/get_user_profile_usecase.dart';
import 'package:social_app/features/user/domain/usecases/search_user_profile_usecase.dart';
import 'package:social_app/features/user/domain/usecases/update_user_profile_usecase.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserByIdUsecase _getUserByIdUsecase;
  final GetUserProfileUsecase _getUserProfileUsecase;
  final SearchUserProfileUsecase _searchUserProfileUsecase;
  final UpdateUserProfileUsecase _updateUserProfileUsecase;

  final UserLocalDataSource _localDataSource;

  UserCubit({
    required GetUserByIdUsecase getUserByIdUsecase,
    required GetUserProfileUsecase getUserProfileUsecase,
    required SearchUserProfileUsecase searchUserProfileUsecase,
    required UpdateUserProfileUsecase updateUserProfileUsecase,
    required UserLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource,
       _getUserByIdUsecase = getUserByIdUsecase,
       _getUserProfileUsecase = getUserProfileUsecase,
       _searchUserProfileUsecase = searchUserProfileUsecase,
       _updateUserProfileUsecase = updateUserProfileUsecase,
       super(UserState.initial());

  Future<void> initializeSession() async {
    await _loadCachedProfile();
    await getProfile();
  }

  Future<void> getProfile() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final user = await _getUserProfileUsecase();
      final usersById = Map<String, UserEntity>.from(state.usersById);
      final preloadedUserIds = Set<String>.from(state.preloadedUserIds);
      usersById[user.id] = user;
      preloadedUserIds.add(user.id);

      emit(
        state.copyWith(
          isLoading: false,
          clearError: true,
          profile: user,
          usersById: usersById,
          preloadedUserIds: preloadedUserIds,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
          clearError: false,
        ),
      );
    }
  }

  Future<void> preloadUsers(List<String> ids) async {
    final preloadedUserIds = Set<String>.from(state.preloadedUserIds);
    final missingIds = ids
        .where((id) => id.isNotEmpty && !preloadedUserIds.contains(id))
        .toSet()
        .toList();

    if (missingIds.isEmpty) {
      return;
    }

    final cachedUsersByIdModels = await _localDataSource.getCachedUsersByIds(
      missingIds,
    );

    final nextUsersById = Map<String, UserEntity>.from(state.usersById);

    for (final cachedUser in cachedUsersByIdModels.values) {
      final user = UserMapper.toEntity(cachedUser);
      nextUsersById[user.id] = user;
      preloadedUserIds.add(user.id);
    }

    emit(
      state.copyWith(
        clearError: true,
        usersById: nextUsersById,
        preloadedUserIds: preloadedUserIds,
      ),
    );

    final remainingIds = missingIds
        .where((id) => !nextUsersById.containsKey(id))
        .toList();

    if (remainingIds.isEmpty) {
      return;
    }

    for (final id in remainingIds) {
      try {
        final user = await _getUserByIdUsecase(id);
        if (user != null) {
          nextUsersById[user.id] = user;
          preloadedUserIds.add(user.id);
        }
      } catch (_) {
        // Ignore individual preload failures and keep existing cache.
        preloadedUserIds.add(id);
      }
    }

    emit(
      state.copyWith(
        clearError: true,
        usersById: nextUsersById,
        preloadedUserIds: preloadedUserIds,
      ),
    );
  }

  UserEntity? getCachedUser(String id) {
    return state.usersById[id];
  }

  void clear() {
    emit(UserState.initial());
  }

  Future<void> _loadCachedProfile() async {
    try {
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser == null) {
        return;
      }

      final user = UserMapper.toEntity(cachedUser);
      final usersById = Map<String, UserEntity>.from(state.usersById);
      final preloadedUserIds = Set<String>.from(state.preloadedUserIds);
      usersById[user.id] = user;
      preloadedUserIds.add(user.id);

      emit(
        state.copyWith(
          isLoading: false,
          clearError: true,
          profile: user,
          usersById: usersById,
          preloadedUserIds: preloadedUserIds,
        ),
      );
    } catch (_) {
      // Ignore cache bootstrap failures and continue to remote fetch.
    }
  }
}
