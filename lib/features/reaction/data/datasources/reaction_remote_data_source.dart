import 'package:social_app/core/core.dart';
import 'package:social_app/core/data/http/api_client.dart';
import 'package:social_app/core/utils/app_constants.dart';
import 'package:social_app/features/reaction/data/models/reaction_model.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';

abstract class ReactionRemoteDataSource {
  /// React to a target (post or comment)
  Future<ReactionResponseModel> react({
    required ReactionTargetType targetType,
    required String targetId,
    required ReactionType type,
  });

  /// Get reaction summary for a target
  Future<List<ReactionSummaryModel>> getReactionSummary({
    required ReactionTargetType targetType,
    required String targetId,
  });

  /// Get user's reaction for a specific target
  Future<ReactionModel?> getUserReaction({
    required ReactionTargetType targetType,
    required String targetId,
  });
}

class ReactionRemoteDataSourceImpl implements ReactionRemoteDataSource {
  final ApiClient apiClient;

  ReactionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ReactionResponseModel> react({
    required ReactionTargetType targetType,
    required String targetId,
    required ReactionType type,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: ApiEndpoints.react,
      body: {
        'targetType': targetType.value,
        'targetId': targetId,
        'type': type.value,
      },
    );

    return ReactionResponseModel.fromJson(response);
  }

  @override
  Future<List<ReactionSummaryModel>> getReactionSummary({
    required ReactionTargetType targetType,
    required String targetId,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: ApiEndpoints.reactsummary,
      body: {'targetType': targetType.value, 'targetId': targetId},
    );

    // Handle both direct list response and wrapped response
    final data = response['data'] ?? response;
    if (data is List) {
      return data
          .map(
            (json) =>
                ReactionSummaryModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    }

    return [];
  }

  @override
  Future<ReactionModel?> getUserReaction({
    required ReactionTargetType targetType,
    required String targetId,
  }) async {
    try {
      final response = await apiClient.request(
        method: 'GET',
        endpoint: ApiEndpoints.userReaction,
        query: {'targetType': targetType.value, 'targetId': targetId},
      );

      if (response.isEmpty) {
        return null;
      }

      return ReactionModel.fromJson(response);
    } catch (e) {
      // If no reaction found, return null instead of throwing
      return null;
    }
  }
}
