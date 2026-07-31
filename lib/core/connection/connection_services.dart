// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../features/track/presentation/controller/track_controller.dart';
import '../app_utils.dart';
import '../services/toasts.dart';

enum NetworkStatus { online, offline }

class InternetConnectionService {
  // Singleton
  static final InternetConnectionService _instance =
      InternetConnectionService._internal();
  factory InternetConnectionService() => _instance;
  InternetConnectionService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<InternetConnectionStatus>? _internetCheckerSubscription;

  final StreamController<NetworkStatus> _controller =
      StreamController<NetworkStatus>.broadcast();

  Stream<NetworkStatus> get stream => _controller.stream;

  NetworkStatus currentStatus = NetworkStatus.online;

  void init() {
    _monitorInternetConnection();
  }

  void _monitorInternetConnection() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      _setupInternetChecker();
    });
  }

  void _setupInternetChecker() {
    _internetCheckerSubscription?.cancel();

    _internetCheckerSubscription = InternetConnectionChecker.createInstance()
        .onStatusChange
        .listen((status) {
          if (status == InternetConnectionStatus.connected) {
            currentStatus = NetworkStatus.online;
            _controller.add(NetworkStatus.online);
            if (Get.isRegistered<TrackController>()) {
              final trackController = Get.find<TrackController>();
              trackController.resumeSimulation();
            }
            ScaffoldMessenger.of(
              AppUtils.navigatorKey.currentContext!,
            ).hideCurrentSnackBar();
          } else {
            currentStatus = NetworkStatus.offline;
            _controller.add(NetworkStatus.offline);
            AppToast.connectionErrorToast();
            if (Get.isRegistered<TrackController>()) {
              final trackController = Get.find<TrackController>();
              trackController.pauseSimulation();
            }
          }
        });
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _internetCheckerSubscription?.cancel();
    _controller.close();
  }
}
