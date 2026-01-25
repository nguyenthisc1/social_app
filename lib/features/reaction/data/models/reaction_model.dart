import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';

/// Reaction target model
class ReactionTargetModel {
  final ReactionTargetType type;
  final String id;

  ReactionTargetModel({
    required this.type,
    required this.id,
  });

  factory ReactionTargetModel.fromJson(Map<String, dynamic> json) {
    return ReactionTargetModel(
      type: ReactionTargetTypeExtension.fromString(json['type'] as String),
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'id': id,
    };
  }
}

/// Reaction model
class ReactionModel {
  final String id;
  final String userId;
  final ReactionTargetModel target;
  final ReactionType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReactionModel({
    required this.id,
    required this.userId,
    required this.target,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      target: ReactionTargetModel.fromJson(json['target'] as Map<String, dynamic>),
      type: ReactionTypeExtension.fromString(json['type'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'target': target.toJson(),
      'type': type.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Reaction summary model
class ReactionSummaryModel {
  final ReactionType type;
  final int count;

  ReactionSummaryModel({
    required this.type,
    required this.count,
  });

  factory ReactionSummaryModel.fromJson(Map<String, dynamic> json) {
    return ReactionSummaryModel(
      type: ReactionTypeExtension.fromString(json['_id'] as String),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': type.value,
      'count': count,
    };
  }
}

/// Reaction response model
class ReactionResponseModel {
  final ReactionAction action;

  ReactionResponseModel({required this.action});

  factory ReactionResponseModel.fromJson(Map<String, dynamic> json) {
    return ReactionResponseModel(
      action: ReactionActionExtension.fromString(json['action'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action.value,
    };
  }
}
