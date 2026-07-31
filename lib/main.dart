import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freelance/core/services/map_services.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:toastification/toastification.dart';

import 'core/app_utils.dart';
import 'core/connection/connection_services.dart';
import 'core/constants/colors.dart';

import 'core/services/ffi_services.dart';
import 'core/services/hive_services.dart';
import 'core/services/ios_check.dart';
 
import 'routes/pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (Platform.isIOS) {
    await IosCheckServices.checkAndRunFirstLaunch();
  }

  await HiveService.instance.init();
  MapServices.getOrAddCustomMarker();
  MapServices.carMarker();
  MapboxOptions.setAccessToken(FFIHelper.fetchStringFromC());

  runApp(ToastificationWrapper(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NetworkStatus>(
      stream: InternetConnectionService().stream,
      initialData: InternetConnectionService().currentStatus,
      builder: (context, snapshot) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: AppUtils.navigatorKey,
          getPages: AppRoutes.getRoutes,
          title: 'Task',
          theme: ThemeData(
            useMaterial3: false,
            fontFamily: "main",
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
          ),
        );
      },
    );
  }
}
