import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/user/application/cubit/user_state.dart';
import 'package:social_app/features/user/data/datasources/local/user_local_data_source.dart';
import 'package:social_app/features/user/data/mappers/user_mapper.dart';
import 'package:social_app/features/user/domain/entites/user_entity.dart';
import 'package:social_app/features/user/domain/usecases/get_user_profile_usecase.dart';
import 'package:social_app/features/user/domain/usecases/get_users_by_ids_usecase.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserProfileUsecase _getUserProfileUsecase;
  final GetUsersByIdsUsecase _getUsersByIdsUsecase;

  final UserLocalDataSource _localDataSource;

  UserCubit({
    required GetUserProfileUsecase getUserProfileUsecase,
    required GetUsersByIdsUsecase getUsersByIdsUsecase,
    required UserLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource,
       _getUserProfileUsecase = getUserProfileUsecase,
       _getUsersByIdsUsecase = getUsersByIdsUsecase,
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
      usersById[user.id] = user;

      emit(
        state.copyWith(
          isLoading: false,
          clearError: true,
          profile: user,
          usersById: usersById,
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

  Future<void> fetchUsersByIds(List<String> ids) async {
    final missingIds = ids
        .where((id) => id.isNotEmpty && !state.usersById.containsKey(id))
        .toSet()
        .toList();

    if (missingIds.isEmpty) {
      return;
    }

    try {
      final nextUsersById = Map<String, UserEntity>.from(state.usersById);
      final users = await _getUsersByIdsUsecase(missingIds);

      for (final user in users) {
        nextUsersById[user.id] = user;
      }

      emit(state.copyWith(clearError: true, usersById: nextUsersById));
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString(), clearError: false));
    }
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
      usersById[user.id] = user;
      emit(
        state.copyWith(
          isLoading: false,
          clearError: true,
          profile: user,
          usersById: usersById,
        ),
      );
    } catch (_) {
      // Ignore cache bootstrap failures and continue to remote fetch.
    }
  }

  UserEntity? getCachedUser(String id) {
    return state.usersById[id];
  }
}
