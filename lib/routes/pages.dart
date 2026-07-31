import 'package:get/get.dart';

import '../features/login/binding/login_bindings.dart';
import '../features/login/presentation/login_screen.dart';
import '../features/request_service/binding/request_services_bindings.dart';
import '../features/request_service/presentation/request_services_screen.dart';
import '../features/splash_screen.dart';
import '../features/track/binding/track_binding.dart';
import '../features/track/presentation/track_screen.dart';
import 'paths.dart';

class AppRoutes {
  static List<GetPage> getRoutes = [
    GetPage(name: AppPaths.initial, page: () => const SplashScreen()),
    GetPage(
      name: AppPaths.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      // middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppPaths.requestServices,
      page: () => const RequestServicesScreen(),
      binding: RequestServicesBindings(),
    ),

    GetPage(
      name: AppPaths.track,
      page: () => const TrackScreen(),
      binding: TrackBinding(),
    ),
  ];
}
