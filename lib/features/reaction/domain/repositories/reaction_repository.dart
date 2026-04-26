import 'package:social_app/features/reaction/domain/entities/reaction_entity.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';

abstract class ReactionRepository {
  /// React to a target (post or comment)
  /// Returns the action performed (created, updated, or removed)
  Future<ReactionResponseEntity> react({
    required ReactionTargetType targetType,
    required String targetId,
    required ReactionType type,
  });

  /// Get reaction summary for a target
  Future<List<ReactionSummaryEntity>> getReactionSummary({
    required ReactionTargetType targetType,
    required String targetId,
  });

  /// Get user's reaction for a specific target (optional feature)
  Future<ReactionEntity?> getUserReaction({
    required ReactionTargetType targetType,
    required String targetId,
  });
}
