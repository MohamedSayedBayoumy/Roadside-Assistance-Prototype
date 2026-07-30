import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import 'core/app_utils.dart';
import 'core/constants/colors.dart';
import 'routes/pages.dart';

Future<void> main() async {
  runApp(ToastificationWrapper(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
