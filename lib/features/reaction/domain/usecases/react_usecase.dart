import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_entity.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';
import 'package:social_app/features/reaction/domain/repositories/reaction_repository.dart';

/// Use case for reacting to a post or comment
class ReactUsecase {
  final ReactionRepository repository;

  ReactUsecase({required this.repository});

  /// Execute reaction
  /// - Creates a new reaction if none exists
  /// - Removes the reaction if the same type is clicked again
  /// - Updates the reaction if a different type is selected
  Future<Either<Failure, ReactionResponseEntity>> call({
    required ReactionTargetType targetType,
    required String targetId,
    required ReactionType type,
  }) async {
    return await repository.react(
      targetType: targetType,
      targetId: targetId,
      type: type,
    );
  }
}
