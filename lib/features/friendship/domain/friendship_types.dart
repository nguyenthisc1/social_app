import 'package:equatable/equatable.dart';

class SendFriendRequestCommand extends Equatable {
  final String toUserId;

  const SendFriendRequestCommand({required this.toUserId});

  @override
  List<Object?> get props => [toUserId];
}

class AcceptFriendRequestCommand extends Equatable {
  final String requestId;

  const AcceptFriendRequestCommand({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

class RejectFriendRequestCommand extends Equatable {
  final String requestId;

  const RejectFriendRequestCommand({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

class GetUserFriendsQuery extends Equatable {
  final String userId;

  const GetUserFriendsQuery({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CheckFriendshipStatusQuery extends Equatable {
  final String userAId;
  final String userBId;

  const CheckFriendshipStatusQuery({
    required this.userAId,
    required this.userBId,
  });

  @override
  List<Object?> get props => [userAId, userBId];
}
