/// Reaction type enum
enum ReactionType {
  like,
  love,
  haha,
  wow,
  sad,
  angry;

  String get value => name;
}

/// Reaction target type enum
enum ReactionTargetType {
  post,
  comment;

  String get value => name;
}

/// Reaction action result
enum ReactionAction {
  created,
  updated,
  removed;

  String get value => name;
}

/// Extension for ReactionType
extension ReactionTypeExtension on ReactionType {
  /// Get display emoji for reaction type
  String get emoji {
    switch (this) {
      case ReactionType.like:
        return '👍';
      case ReactionType.love:
        return '❤️';
      case ReactionType.haha:
        return '😂';
      case ReactionType.wow:
        return '😮';
      case ReactionType.sad:
        return '😢';
      case ReactionType.angry:
        return '😠';
    }
  }

  /// Get display label for reaction type
  String get label {
    switch (this) {
      case ReactionType.like:
        return 'Like';
      case ReactionType.love:
        return 'Love';
      case ReactionType.haha:
        return 'Haha';
      case ReactionType.wow:
        return 'Wow';
      case ReactionType.sad:
        return 'Sad';
      case ReactionType.angry:
        return 'Angry';
    }
  }

  /// Parse from string
  static ReactionType fromString(String value) {
    return ReactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ReactionType.like,
    );
  }
}

/// Extension for ReactionTargetType
extension ReactionTargetTypeExtension on ReactionTargetType {
  /// Parse from string
  static ReactionTargetType fromString(String value) {
    return ReactionTargetType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ReactionTargetType.post,
    );
  }
}

/// Extension for ReactionAction
extension ReactionActionExtension on ReactionAction {
  /// Parse from string
  static ReactionAction fromString(String value) {
    return ReactionAction.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ReactionAction.created,
    );
  }
}
