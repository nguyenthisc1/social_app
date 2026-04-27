import 'package:equatable/equatable.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';

/// Reaction entity representing a user's reaction to a post or comment
class ReactionEntity extends Equatable {
  final String id;
  final String userId;
  final ReactionTargetType targetType;
  final String targetId;
  final ReactionType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReactionEntity({
    required this.id,
    required this.userId,
    required this.targetType,
    required this.targetId,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        targetType,
        targetId,
        type,
        createdAt,
        updatedAt,
      ];

  ReactionEntity copyWith({
    String? id,
    String? userId,
    ReactionTargetType? targetType,
    String? targetId,
    ReactionType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReactionEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Reaction summary entity
class ReactionSummaryEntity extends Equatable {
  final ReactionType type;
  final int count;

  const ReactionSummaryEntity({
    required this.type,
    required this.count,
  });

  @override
  List<Object?> get props => [type, count];

  ReactionSummaryEntity copyWith({
    ReactionType? type,
    int? count,
  }) {
    return ReactionSummaryEntity(
      type: type ?? this.type,
      count: count ?? this.count,
    );
  }
}

/// Reaction response entity
class ReactionResponseEntity extends Equatable {
  final ReactionAction action;

  const ReactionResponseEntity({required this.action});

  @override
  List<Object?> get props => [action];
}
