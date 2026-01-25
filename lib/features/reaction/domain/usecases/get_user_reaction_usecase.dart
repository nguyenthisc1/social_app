import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_entity.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';
import 'package:social_app/features/reaction/domain/repositories/reaction_repository.dart';

/// Use case for getting user's reaction to a specific target
class GetUserReactionUsecase {
  final ReactionRepository repository;

  GetUserReactionUsecase({required this.repository});

  /// Get the current user's reaction for a target (if any)
  /// Returns null if user hasn't reacted
  Future<Either<Failure, ReactionEntity?>> call({
    required ReactionTargetType targetType,
    required String targetId,
  }) async {
    return await repository.getUserReaction(
      targetType: targetType,
      targetId: targetId,
    );
  }
}
