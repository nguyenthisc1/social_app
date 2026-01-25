import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/friendship/data/datasources/friendship_remote_data_source.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/mappers/friendship_mapper.dart';
import 'package:social_app/features/friendship/domain/repositories/friendship_repository.dart';

class FriendshipRepositoryImpl implements FriendshipRepository {
  final FriendshipRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FriendshipRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, FriendshipResponseEntity>> sendRequest({
    required String toUserId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.sendRequest(toUserId: toUserId);
      return Right(FriendshipMapper.toResponseEntity(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to send friend request: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, FriendshipResponseEntity>> acceptRequest({
    required String requestId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.acceptRequest(requestId: requestId);
      return Right(FriendshipMapper.toResponseEntity(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to accept friend request: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, FriendshipResponseEntity>> rejectRequest({
    required String requestId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.rejectRequest(requestId: requestId);
      return Right(FriendshipMapper.toResponseEntity(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to reject friend request: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<FriendRequestEntity>>> getPendingRequests() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.getPendingRequests();
      return Right(FriendshipMapper.toRequestEntityList(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get pending requests: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<FriendRequestEntity>>> getSentRequests() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.getSentRequests();
      return Right(FriendshipMapper.toRequestEntityList(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get sent requests: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<FriendEntity>>> getFriends() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.getFriends();
      return Right(FriendshipMapper.toFriendEntityList(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get friends: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<FriendEntity>>> getUserFriends({
    required String userId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.getUserFriends(userId: userId);
      return Right(FriendshipMapper.toFriendEntityList(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get user friends: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, FriendshipStatusEntity>> isFriend({
    required String userAId,
    required String userBId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.isFriend(
        userAId: userAId,
        userBId: userBId,
      );
      return Right(FriendshipMapper.toStatusEntity(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to check friendship status: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFriendIds() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.getFriendIds();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get friend IDs: ${e.toString()}',
      ));
    }
  }
}
