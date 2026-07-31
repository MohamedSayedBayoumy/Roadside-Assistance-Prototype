import 'package:get/get.dart';

import '../presentation/controller/track_controller.dart';


class TrackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackController>(() => TrackController());
  }
}
