import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/connection/connection_services.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controller/track_controller.dart';

class StartEndTripButtonWidget extends GetView<TrackController> {
  const StartEndTripButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isOffline =
          controller.connectionStatus.value == ConnectionStatus.offline;

      return IgnorePointer(
        ignoring: isOffline,
        child: Opacity(
          opacity: isOffline ? 0.5 : 1.0,
          child: ZoomIn(
            child: CustomButton(
              text: controller.isTripActive.value == false ? "Start" : "End",
              onPressed: () {
                if (controller.isTripActive.value == false) {
                  controller.startSmoothDriverSimulation();
                } else {
                  controller.cancelTrip();
                }
              },
            ),
          ),
        ),
      );
    });
  }
}
