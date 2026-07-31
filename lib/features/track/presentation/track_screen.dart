import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/widgets/custom_loading.dart';
import 'controller/track_controller.dart';
import 'widgets/bottom_sheet_widget.dart';

class TrackScreen extends GetView<TrackController> {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        if (!controller.isLayoutReady.value) {
          return const CustomLoading();
        }

        return Stack(
          children: [
            MapWidget(
              key: const ValueKey("mapWidget"),
              onMapCreated: (mapController) =>
                  controller.onMapCreated(mapController, context),
              cameraOptions: CameraOptions(zoom: 4.0, pitch: 0.0),
            ),

            BottomSheetWidget(controller: controller),
          ],
        );
      }),
    );
  }
}
