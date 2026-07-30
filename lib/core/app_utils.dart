import 'package:flutter/material.dart';

abstract class AppUtils {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '• Email is required';
    }
    List<String> errors = [];
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegExp.hasMatch(value.trim())) {
      errors.add('• Invalid email address format');
    }

    if (errors.isNotEmpty) {
      return errors.join('\n');
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '• Password is required';
    }
    List<String> errors = [];

    if (value.length < 8) {
      errors.add('• Must be at least 8 characters long');
    }

    // if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
    //   errors.add('• Must contain at least one uppercase letter');
    // }

    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      errors.add('• Must contain at least one lowercase letter');
    }

    if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
      errors.add('• Must contain at least one number');
    }

    if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) {
      errors.add('• Must contain at least one special character');
    }

    if (errors.isNotEmpty) {
      return errors.join('\n');
    }

    return null;
  }
}
