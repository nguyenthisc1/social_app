import 'package:equatable/equatable.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';

class ReactCommand extends Equatable {
  final ReactionTargetType targetType;
  final String targetId;
  final ReactionType type;

  const ReactCommand({
    required this.targetType,
    required this.targetId,
    required this.type,
  });

  @override
  List<Object?> get props => [targetType, targetId, type];
}

class GetReactionSummaryQuery extends Equatable {
  final ReactionTargetType targetType;
  final String targetId;

  const GetReactionSummaryQuery({
    required this.targetType,
    required this.targetId,
  });

  @override
  List<Object?> get props => [targetType, targetId];
}

class GetUserReactionQuery extends Equatable {
  final ReactionTargetType targetType;
  final String targetId;

  const GetUserReactionQuery({
    required this.targetType,
    required this.targetId,
  });

  @override
  List<Object?> get props => [targetType, targetId];
}
