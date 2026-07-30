import 'package:flutter/material.dart';
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
}
