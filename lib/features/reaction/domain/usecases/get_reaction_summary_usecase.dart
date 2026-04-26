import 'package:social_app/features/reaction/domain/entities/reaction_entity.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';
import 'package:social_app/features/reaction/domain/repositories/reaction_repository.dart';

/// Use case for getting reaction summary
class GetReactionSummaryUsecase {
  final ReactionRepository repository;

  GetReactionSummaryUsecase({required this.repository});

  /// Get aggregated reaction counts for a target
  Future<List<ReactionSummaryEntity>> call({
    required ReactionTargetType targetType,
    required String targetId,
  }) async {
    return await repository.getReactionSummary(
      targetType: targetType,
      targetId: targetId,
    );
  }
}
