import 'package:social_app/features/user/domain/entites/user_entity.dart';

class UserState {
  final bool isLoading;
  final String? errorMessage;
  final UserEntity? profile;
  final Map<String, UserEntity> usersById;

  const UserState({
    required this.isLoading,
    this.errorMessage,
    required this.profile,
    required this.usersById,
  });

  factory UserState.initial() {
    return const UserState(
      isLoading: true,
      errorMessage: null,
      profile: null,
      usersById: {},
    );
  }

  UserState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    UserEntity? profile,
    Map<String, UserEntity>? usersById,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      profile: profile ?? this.profile,
      usersById: usersById ?? this.usersById,
    );
  }
}
