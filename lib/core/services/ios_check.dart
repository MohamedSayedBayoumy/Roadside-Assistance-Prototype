import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_keys.dart';
import 'flutter_secure_storage.dart';

class IosCheckServices {
  static late SharedPreferences sharedPreferences;

  static Future<void> checkAndRunFirstLaunch() async {
    sharedPreferences = await SharedPreferences.getInstance();

    final isFirstTime = sharedPreferences.getBool(AppKeys.isFirstLaunchIos);

    if (isFirstTime == null) {
      await sharedPreferences.setBool(AppKeys.isFirstLaunchIos, true);

      await SecureStorageService.clearAll();
    }
  }
}
