import 'package:get/get.dart';

import '../../../core/network/dio_services.dart';
import '../data/remote_data/track_remote_data.dart';
import '../data/track_data_repos.dart/track_data_repos.dart';
import '../domain/repos/track_repos.dart';
import '../domain/use_case/track_use_case.dart';
import '../presentation/controller/track_controller.dart';

class TrackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackRemoteData>(
      () => TrackRemoteDataImpel(DioServices()),
      fenix: true,
      // remove Dependency from memory and back inject when call as first time 
    );

    Get.lazyPut<TrackRepos>(
      () => TrackDataRepos(trackRemoteData: Get.find()),
      fenix: true,
    );

    Get.lazyPut<TrackUseCase>(
      () => TrackUseCase(trackRepos: Get.find()),
      fenix: true,
    );

    Get.lazyPut<TrackController>(
      () => TrackController(trackUseCase: Get.find()),
    );
  }
}
