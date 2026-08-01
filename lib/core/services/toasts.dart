import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../app_utils.dart';

abstract class AppToast {
  static void success({required String description, String? title}) {
    toastification.show(
      context: AppUtils.navigatorKey.currentContext,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: Text(
        title ?? 'Success',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(description),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  /// Failed Toast
  static void failed({required String description, String? title}) {
    toastification.show(
      context: AppUtils.navigatorKey.currentContext,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text(
        title ?? 'Failed',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(description),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  /// Warning Toast
  static void warning({required String description, String? title}) {
    toastification.show(
      context: AppUtils.navigatorKey.currentContext,
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      title: Text(
        title ?? 'Warning',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(description),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static void connectionErrorToast() {
    Get.rawSnackbar(
      title: 'No Internet Connection',
      message: 'Please check your internet connection or Wi-Fi',
      isDismissible: true,
      duration: const Duration(days: 1),
      backgroundColor: Colors.red[800]!,
      icon: const Icon(Icons.wifi_off, color: Colors.white),
      margin: EdgeInsets.zero,
      borderRadius: 0,
      snackPosition: SnackPosition.TOP,
    );
  }

  static void connectionToast() {
    Get.rawSnackbar(
      title: 'Connection Restored',
      message: 'You are back online',
      backgroundColor: Colors.green[800]!,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.wifi, color: Colors.white),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      snackPosition: SnackPosition.TOP,
    );
  }
}
