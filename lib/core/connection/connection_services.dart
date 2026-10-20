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


// import 'dart:async';
// import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';

// enum ConnectionStatus { connected, offline }

// class NetworkService {
//   NetworkService._internal();
//   static final NetworkService _instance = NetworkService._internal();
//   factory NetworkService() => _instance;

//   final _statusController = StreamController<ConnectionStatus>.broadcast();
//   StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
//   Timer? _debounceTimer;

//   Stream<ConnectionStatus> get statusStream =>
//       _statusController.stream.distinct();

//   ConnectionStatus _currentStatus = ConnectionStatus.offline; // Default to offline until proven otherwise
//   ConnectionStatus get currentStatus => _currentStatus;

//   void initialize() {
//     checkConnection();
//     _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
//       // الـ Debouncer: عشان لو الشبكة بتلعب، مشيكش غير لما تستقر ثانية واحدة
//       _debounceTimer?.cancel();
//       _debounceTimer = Timer(const Duration(seconds: 1), () {
//         checkConnection(connectivityResult: result);
//       });
//     });
//   }

//   Future<void> checkConnection({
//     List<ConnectivityResult>? connectivityResult,
//   }) async {
//     final results =
//         connectivityResult ?? await Connectivity().checkConnectivity();

//     if (results.contains(ConnectivityResult.none)) {
//       _updateStatus(ConnectionStatus.offline);
//       return;
//     }

//     bool hasInternet = await _hasActualInternet();
//     _updateStatus(
//       hasInternet ? ConnectionStatus.connected : ConnectionStatus.offline,
//     );
//   }

//   // التعديل الجوهري: Socket بدل DNS Lookup عشان نتفادى الـ Cache ونحط Timeout
//   Future<bool> _hasActualInternet() async {
//     try {
//       // بنحاول نفتح اتصال فعلي بسيرفر جوجل للـ DNS على بورت 53
//       final socket = await Socket.connect('8.8.8.8', 53,
//           timeout: const Duration(seconds: 3)); // Timeout صريح بـ 3 ثواني
//       socket.destroy(); // فتحناه وقفلوه فوراً، الغرض التأكد بس
//       return true;
//     } on SocketException catch (_) {
//       return false;
//     } on TimeoutException catch (_) {
//       // لو الباقة ميتة ومفيش رد في 3 ثواني
//       return false;
//     } catch (_) {
//       return false;
//     }
//   }

//   void _updateStatus(ConnectionStatus status) {
//     if (_currentStatus != status) {
//       _currentStatus = status;
//       _statusController.add(status);
//     }
//   }

//   void dispose() {
//     _debounceTimer?.cancel();
//     _connectivitySubscription?.cancel();
//     _statusController.close();
//   }
// }
