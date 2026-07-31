import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:freelance/core/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../../../core/constants/images.dart';
import '../controller/track_controller.dart';
import 'location_input_field.dart';

class BottomSheetBodyWidget extends GetView<TrackController> {
  const BottomSheetBodyWidget({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(15),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          CustomLocationInputField(
            icon: AppImages.hand,
            hintText: "From",
            controller: controller.fromPoint.value.controller,
            trackingScrollController: controller,
            showPickIcon: false,
          ),

          SizedBox(height: 10),

          CustomLocationInputField(
            icon: AppImages.flag,
            hintText: "To",
            controller: controller.toPoint.value.controller,
            trackingScrollController: controller,
            callBackWithAddress: (address) {
              controller.toPoint.value = address.value;
              controller.getDirections(point: address.value);
            },
          ),

          SizedBox(height: 30),

          if (controller.toPoint.value.lat != null) ...[
            ZoomIn(
              delay: Duration(seconds: 1),
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
          ],
        ],
      );
    });
  }
}
