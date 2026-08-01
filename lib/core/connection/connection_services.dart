import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectionStatus { connected, offline }

class NetworkService {
  NetworkService._internal();
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  final _statusController = StreamController<ConnectionStatus>.broadcast();

  Stream<ConnectionStatus> get statusStream =>
      _statusController.stream.distinct();

  ConnectionStatus _currentStatus = ConnectionStatus.connected;
  ConnectionStatus get currentStatus => _currentStatus;

  void initialize() {
    checkConnection();
    Connectivity().onConnectivityChanged.listen((result) {
      checkConnection(connectivityResult: result);
    });
  }

  Future<void> checkConnection({
    List<ConnectivityResult>? connectivityResult,
  }) async {
    final results =
        connectivityResult ?? await Connectivity().checkConnectivity();

    if (results.contains(ConnectivityResult.none)) {
      _updateStatus(ConnectionStatus.offline);
      return;
    }

    bool hasInternet = await _hasActualInternet();
    _updateStatus(
      hasInternet ? ConnectionStatus.connected : ConnectionStatus.offline,
    );
  }

  Future<bool> _hasActualInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _updateStatus(ConnectionStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _statusController.add(status);
    }
  }

  void dispose() {
    _statusController.close();
  }
}
