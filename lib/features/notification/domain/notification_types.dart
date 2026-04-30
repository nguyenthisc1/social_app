import 'package:equatable/equatable.dart';

class SyncFcmTokenCommand extends Equatable {
  final String userId;
  final String token;

  const SyncFcmTokenCommand({
    required this.userId,
    required this.token,
  });

  @override
  List<Object?> get props => [userId, token];
}
