// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../routes/paths.dart';
// import 'flutter_secure_storage.dart';

// class AuthMiddleware extends GetMiddleware {
//   @override
//   RouteSettings? redirect(String? route) {
//     final isLoggedIn = SecureStorageService.isAuthenticated;

//     if (isLoggedIn) {
//       return const RouteSettings(name: AppPaths.requestServices);
//     }

//     return null;
//   }
// }
