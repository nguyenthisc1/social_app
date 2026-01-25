import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/reaction/data/datasources/reaction_remote_data_source.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_entity.dart';
import 'package:social_app/features/reaction/domain/entities/reaction_enums.dart';
import 'package:social_app/features/reaction/domain/mappers/reaction_mapper.dart';
import 'package:social_app/features/reaction/domain/repositories/reaction_repository.dart';

class ReactionRepositoryImpl implements ReactionRepository {
  final ReactionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ReactionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ReactionResponseEntity>> react({
    required ReactionTargetType targetType,
    required String targetId,
    required ReactionType type,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.react(
        targetType: targetType,
        targetId: targetId,
        type: type,
      );

      return Right(ReactionMapper.toResponseEntity(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to react: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<ReactionSummaryEntity>>> getReactionSummary({
    required ReactionTargetType targetType,
    required String targetId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.getReactionSummary(
        targetType: targetType,
        targetId: targetId,
      );

      return Right(ReactionMapper.toSummaryEntityList(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get reaction summary: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, ReactionEntity?>> getUserReaction({
    required ReactionTargetType targetType,
    required String targetId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.getUserReaction(
        targetType: targetType,
        targetId: targetId,
      );

      if (result == null) {
        return const Right(null);
      }

      return Right(ReactionMapper.toEntity(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get user reaction: ${e.toString()}',
      ));
    }
  }
}
