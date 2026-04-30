import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/app/internet_connection/connection_status.dart';
import 'package:social_app/app/internet_connection/cubit/internet_connection_state.dart';
import 'package:social_app/app/internet_connection/network_info.dart';

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  final NetworkInfo _networkInfo;
  StreamSubscription<ConnectionStatus>? _subscription;

  InternetConnectionCubit({required NetworkInfo networkInfo})
    : _networkInfo = networkInfo,
      super(const InternetConnectionState.initial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final status = await _networkInfo.connectionStatus;
    emit(state.copyWith(status: status));

    _subscription = _networkInfo.onStatusChange.listen((status) {
      emit(state.copyWith(status: status));
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
