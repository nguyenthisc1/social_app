class NotificationState {
  final bool isLoading;
  final bool permissionGranted;
  final String? token;
  final String? errorMessage;

  const NotificationState({
    required this.isLoading,
    required this.permissionGranted,
    this.token,
    this.errorMessage,
  });

  factory NotificationState.initial() {
    return NotificationState(
      isLoading: false,
      permissionGranted: false,
      token: null,
      errorMessage: null,
    );
  }

  NotificationState copyWith({
    bool? isLoading,
    bool? permissionGranted,
    String? token,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      permissionGranted: permissionGranted ?? this.permissionGranted,
      token: token ?? this.token,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
