import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:social_app/app/internet_connection/connection_status.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<ConnectionStatus> get connectionStatus;
  Stream<ConnectionStatus> get onStatusChange;
}

class NetworkInfoImpl implements NetworkInfo {
  /// Standard checker – used as the primary "is there ANY connection?" probe.
  /// Timeout of 5 s to also catch very slow connections.
  final InternetConnectionChecker _standardChecker;

  /// Fast checker – distinguishes "connected" from "slow".
  /// Timeout of 1 s: succeeds only on reasonably fast connections.
  final InternetConnectionChecker _fastChecker;

  NetworkInfoImpl()
    : _standardChecker = InternetConnectionChecker.createInstance(
        checkTimeout: const Duration(milliseconds: 5000),
        checkInterval: const Duration(seconds: 10),
      ),
      _fastChecker = InternetConnectionChecker.createInstance(
        checkTimeout: const Duration(milliseconds: 1000),
        checkInterval: const Duration(seconds: 10),
      );

  @override
  Future<bool> get isConnected async {
    final status = await connectionStatus;
    return status != ConnectionStatus.disconnected;
  }

  @override
  Future<ConnectionStatus> get connectionStatus async {
    final hasAnyConnection = await _standardChecker.hasConnection;
    if (!hasAnyConnection) return ConnectionStatus.disconnected;

    final hasFastConnection = await _fastChecker.hasConnection;
    return hasFastConnection
        ? ConnectionStatus.connected
        : ConnectionStatus.slow;
  }

  @override
  Stream<ConnectionStatus> get onStatusChange {
    // Whenever the standard checker detects a change, re-run the full quality
    // check so slow / connected / disconnected are all distinguished.
    return _standardChecker.onStatusChange
        .asyncMap((_) => connectionStatus)
        .distinct();
  }
}
