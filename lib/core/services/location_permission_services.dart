import 'package:flutter/material.dart';
import 'package:freelance/core/app_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/open_setting_widget.dart';

abstract class LocationPermissionServices {
  static Future<bool> hasPermission() async {
    var status = await Permission.location.status;
    return status.isGranted;
  }

  static Future<bool> requestLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      if (AppUtils.navigatorKey.currentContext!.mounted) {
        _showSettingsBottomSheet(AppUtils.navigatorKey.currentContext!);
      }
      return false;
    }

    var result = await Permission.location.request();

    if (result.isGranted) {
      return true;
    }

    return false;
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
