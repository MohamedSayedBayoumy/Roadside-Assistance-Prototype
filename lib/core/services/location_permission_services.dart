import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freelance/core/app_utils.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/open_setting_widget.dart';

abstract class LocationPermissionServices {
  static Future<bool> requestLocationPermission() async {
    if (Platform.isAndroid) {
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        await Geolocator.openLocationSettings();
        isServiceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!isServiceEnabled) {
          return false;
        }
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      if (AppUtils.navigatorKey.currentContext != null &&
          AppUtils.navigatorKey.currentContext!.mounted) {
        _showSettingsBottomSheet(AppUtils.navigatorKey.currentContext!);
      }
      return false;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return OpenSettingWidget();
      },
    );
  }
}
