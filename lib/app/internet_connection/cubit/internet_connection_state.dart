import 'package:equatable/equatable.dart';
import 'package:social_app/app/internet_connection/connection_status.dart';

class InternetConnectionState extends Equatable {
  final ConnectionStatus status;

  const InternetConnectionState({required this.status});

  const InternetConnectionState.initial() : status = ConnectionStatus.unknown;

  bool get isUnknown => status == ConnectionStatus.unknown;
  bool get isConnected => status == ConnectionStatus.connected;
  bool get isSlow => status == ConnectionStatus.slow;
  bool get isDisconnected => status == ConnectionStatus.disconnected;

  /// True when any working connection exists (connected OR slow).
  bool get hasInternet => isConnected || isSlow;

  InternetConnectionState copyWith({ConnectionStatus? status}) {
    return InternetConnectionState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
