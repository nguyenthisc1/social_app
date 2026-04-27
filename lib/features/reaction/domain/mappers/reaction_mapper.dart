import 'package:social_app/features/reaction/data/models/reaction_model.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_entity.dart';

/// Mapper for converting between Reaction models and entities
class ReactionMapper {
  ReactionMapper._();

  /// Convert ReactionModel to ReactionEntity
  static ReactionEntity toEntity(ReactionModel model) {
    return ReactionEntity(
      id: model.id,
      userId: model.userId,
      targetType: model.target.type,
      targetId: model.target.id,
      type: model.type,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert ReactionEntity to ReactionModel
  static ReactionModel toModel(ReactionEntity entity) {
    return ReactionModel(
      id: entity.id,
      userId: entity.userId,
      target: ReactionTargetModel(
        type: entity.targetType,
        id: entity.targetId,
      ),
      type: entity.type,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert list of ReactionModel to list of ReactionEntity
  static List<ReactionEntity> toEntityList(List<ReactionModel> models) {
    return models.map(toEntity).toList();
  }

  /// Convert ReactionSummaryModel to ReactionSummaryEntity
  static ReactionSummaryEntity toSummaryEntity(ReactionSummaryModel model) {
    return ReactionSummaryEntity(
      type: model.type,
      count: model.count,
    );
  }

  /// Convert list of ReactionSummaryModel to list of ReactionSummaryEntity
  static List<ReactionSummaryEntity> toSummaryEntityList(
    List<ReactionSummaryModel> models,
  ) {
    return models.map(toSummaryEntity).toList();
  }

  /// Convert ReactionResponseModel to ReactionResponseEntity
  static ReactionResponseEntity toResponseEntity(ReactionResponseModel model) {
    return ReactionResponseEntity(action: model.action);
  }
}
