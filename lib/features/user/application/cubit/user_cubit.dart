import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/user/application/cubit/user_state.dart';
import 'package:social_app/features/user/domain/entites/user.dart';
import 'package:social_app/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:social_app/features/user/domain/usecases/get_user_profile_usecase.dart';
import 'package:social_app/features/user/domain/usecases/search_user_profile_usecase.dart';
import 'package:social_app/features/user/domain/usecases/update_user_profile_usecase.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserByIdUsecase _getUserByIdUsecase;
  final GetUserProfileUsecase _getUserProfileUsecase;
  final SearchUserProfileUsecase _searchUserProfileUsecase;
  final UpdateUserProfileUsecase _updateUserProfileUsecase;

  UserCubit({
    required GetUserByIdUsecase getUserByIdUsecase,
    required GetUserProfileUsecase getUserProfileUsecase,
    required SearchUserProfileUsecase searchUserProfileUsecase,
    required UpdateUserProfileUsecase updateUserProfileUsecase,
  }) : _getUserByIdUsecase = getUserByIdUsecase,
       _getUserProfileUsecase = getUserProfileUsecase,
       _searchUserProfileUsecase = searchUserProfileUsecase,
       _updateUserProfileUsecase = updateUserProfileUsecase,
       super(UserState.initial());

  Future<void> getProfile() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final user = await _getUserProfileUsecase();
      final usersById = Map<String, User>.from(state.usersById);
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

  Future<void> preloadUsers(List<String> ids) async {
    final missingIds = ids
        .where((id) => id.isNotEmpty && !state.usersById.containsKey(id))
        .toSet()
        .toList();

    if (missingIds.isEmpty) {
      return;
    }

    final nextUsersById = Map<String, User>.from(state.usersById);

    for (final id in missingIds) {
      try {
        final user = await _getUserByIdUsecase(id);
        if (user != null) {
          nextUsersById[user.id] = user;
        }
      } catch (_) {
        // Ignore individual preload failures and keep existing cache.
      }
    }

    emit(state.copyWith(clearError: true, usersById: nextUsersById));
  }

  User? getCachedUser(String id) {
    return state.usersById[id];
  }

  void clear() {
    emit(UserState.initial());
  }
}
