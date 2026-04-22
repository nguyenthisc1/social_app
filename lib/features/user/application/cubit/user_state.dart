import 'package:social_app/features/user/domain/entites/user.dart';

class UserState {
  final bool isLoading;
  final String? errorMessage;
  final User? profile;
  final Map<String, User> usersById;

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
    User? profile,
    Map<String, User>? usersById,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      profile: profile ?? this.profile,
      usersById: usersById ?? this.usersById,
    );
  }
}
