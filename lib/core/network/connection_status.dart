import 'dart:async';

import 'package:chatterbox/core/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ConnectionStatusSingleton {
  bool _hasConnection = false;

  // Using the getter method to get input
  bool get hasConnection {
    return _hasConnection;
  }

  // Using the setter method to set the input
  set hasConnection(bool value) {
    _hasConnection = value;
    connectionChangeController.add(value);
  }

  static final ConnectionStatusSingleton _singleton =
      ConnectionStatusSingleton._internal();

  ConnectionStatusSingleton._internal();

  factory ConnectionStatusSingleton() {
    return _singleton;
  }

  StreamController<bool> connectionChangeController =
      StreamController.broadcast();
  final Connectivity _connectivity = Connectivity();
  Stream<bool> get connectionChange => connectionChangeController.stream;

  Future<void> initialize() async {
    _connectivity.onConnectivityChanged.listen(_connectionChange);

    await checkConnection();
  }

  @disposeMethod
  void dispose() {
    connectionChangeController.close();
  }

  void _connectionChange(ConnectivityResult result) async {
    logger.d("_connectivity connection changed: $result");
    await checkConnection();
  }

  checkConnection() async {
    // ping some server to check if connected
    final result = await _connectivity.checkConnectivity();
    logger.d("checkConnectivity result: $result");
    if (result != ConnectivityResult.none) {
      hasConnection = true;
    } else {
      hasConnection = false;
    }
    connectionChangeController.add(_hasConnection);
  }
}
