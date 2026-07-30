import 'package:get/get.dart';

import '../data/login_data_repos/login_data_repos.dart';
import '../domain/login_repo/login_repo.dart';
import '../domain/login_use_case/login_use_case.dart';
import '../presentation/controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRepo>(() => LoginDataRepos());

    Get.lazyPut<LoginUseCase>(() => LoginUseCase(loginRepo: Get.find()));

    Get.lazyPut<LoginController>(() => LoginController(Get.find()));
  }
}
