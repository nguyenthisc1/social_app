import 'package:social_app/core/data/http/network_info.dart';
import 'package:social_app/features/reaction/data/datasources/reaction_remote_data_source.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_entity.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';
import 'package:social_app/features/reaction/domain/mappers/reaction_mapper.dart';
import 'package:social_app/features/reaction/domain/reaction_exceptions.dart';
import 'package:social_app/features/reaction/domain/repositories/reaction_repository.dart';

class ReactionRepositoryImpl implements ReactionRepository {
  final ReactionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ReactionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<ReactionResponseEntity> react({
    required ReactionTargetType targetType,
    required String targetId,
    required ReactionType type,
  }) async {
    if (!await networkInfo.isConnected) {
      throw ReactionSubmitException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at react.',
      );
    }
    try {
      final result = await remoteDataSource.react(
        targetType: targetType,
        targetId: targetId,
        type: type,
      );
      return ReactionMapper.toResponseEntity(result);
    } catch (e) {
      throw ReactionSubmitException(
        debugMessage: 'Failed to submit reaction for targetId=$targetId: $e',
        cause: e,
      );
    }
  }

  @override
  Future<List<ReactionSummaryEntity>> getReactionSummary({
    required ReactionTargetType targetType,
    required String targetId,
  }) async {
    if (!await networkInfo.isConnected) {
      throw ReactionLoadException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at getReactionSummary.',
      );
    }
    try {
      final result = await remoteDataSource.getReactionSummary(
        targetType: targetType,
        targetId: targetId,
      );
      return ReactionMapper.toSummaryEntityList(result);
    } catch (e) {
      throw ReactionLoadException(
        userMessage: 'Unable to load reactions.',
        debugMessage: 'Failed to get reaction summary for targetId=$targetId: $e',
        cause: e,
      );
    }
  }

  @override
  Future<ReactionEntity?> getUserReaction({
    required ReactionTargetType targetType,
    required String targetId,
  }) async {
    if (!await networkInfo.isConnected) {
      throw ReactionLoadException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at getUserReaction.',
      );
    }
    try {
      final result = await remoteDataSource.getUserReaction(
        targetType: targetType,
        targetId: targetId,
      );
      if (result == null) return null;
      return ReactionMapper.toEntity(result);
    } catch (e) {
      throw ReactionLoadException(
        userMessage: 'Unable to load your reaction.',
        debugMessage: 'Failed to get user reaction for targetId=$targetId: $e',
        cause: e,
      );
    }
  }
}
