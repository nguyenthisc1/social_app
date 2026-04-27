/// Friendship request status enum
enum FriendshipStatus {
  pending,
  accepted,
  rejected;

  String get value => name;
}

/// Extension for FriendshipStatus
extension FriendshipStatusExtension on FriendshipStatus {
  /// Get display label for status
  String get label {
    switch (this) {
      case FriendshipStatus.pending:
        return 'Pending';
      case FriendshipStatus.accepted:
        return 'Accepted';
      case FriendshipStatus.rejected:
        return 'Rejected';
    }
  }

  /// Get color representation for status
  String get colorHex {
    switch (this) {
      case FriendshipStatus.pending:
        return '#FFA500'; // Orange
      case FriendshipStatus.accepted:
        return '#4CAF50'; // Green
      case FriendshipStatus.rejected:
        return '#F44336'; // Red
    }
  }

  /// Check if status is pending
  bool get isPending => this == FriendshipStatus.pending;

  /// Check if status is accepted
  bool get isAccepted => this == FriendshipStatus.accepted;

  /// Check if status is rejected
  bool get isRejected => this == FriendshipStatus.rejected;

  /// Parse from string
  static FriendshipStatus fromString(String value) {
    return FriendshipStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => FriendshipStatus.pending,
    );
  }
}
