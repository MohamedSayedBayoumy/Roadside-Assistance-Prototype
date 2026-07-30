import 'package:get/get.dart';

import '../features/login/binding/login_bindings.dart';
import '../features/login/presentation/login_screen.dart';
import '../features/splash_screen.dart';
import '../features/track/presentation/track_screen.dart';
import 'paths.dart';

class AppRoutes {
  static List<GetPage> getRoutes = [
    GetPage(
      name: AppPaths.initial,
      page: () {
        Future.delayed(Duration(seconds: 3), () {
          Get.offAllNamed(AppPaths.login);
        });
        return const SplashScreen();
      },
    ),
    GetPage(
      name: AppPaths.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: AppPaths.requestServices,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),

    GetPage(name: AppPaths.track, page: () => const TrackScreen()),
  ];
}
