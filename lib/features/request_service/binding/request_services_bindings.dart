import 'package:get/get.dart';

import '../presentation/controller/request_services_controller.dart';

class RequestServicesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestServicesController>(() => RequestServicesController());
  }
}
