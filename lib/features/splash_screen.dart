import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/app_keys.dart';
import '../core/constants/fonts.dart';
import '../core/services/flutter_secure_storage.dart';
import '../routes/paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSplash();
    });
  }

  Future<void> _startSplash() async {
    final isLoggedIn = await SecureStorageService.readBool(
      key: AppKeys.isLoggedIn,
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (isLoggedIn) {
        Get.offAllNamed(AppPaths.requestServices);
      } else {
        Get.offAllNamed(AppPaths.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeIn(child: Text("Loading...", style: AppFonts.styleLight25)),
      ),
    );
  }
}
