import 'package:flutter/material.dart';
import 'package:freelance/features/track/presentation/widgets/location_input_field.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/constants/images.dart';
import '../../../core/widgets/custom_loading.dart';
import 'controller/track_controller.dart';

class TrackScreen extends GetView<TrackController> {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onMapIdleListener: (mapIdleEventData) {
                controller.updateAddressFromCenter();
              },
              cameraOptions: CameraOptions(zoom: 4.0, pitch: 0.0),
            ),

            BottomSheetWidget(controller: controller),
          ],
        );
      }),
    );
  }
}

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key, required this.controller});

  final TrackController controller;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.15,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return BottomSheetCardWidget(
          child: BottomSheetBodyWidget(scrollController: scrollController),
        );
      },
    );
  }
}

class BottomSheetBodyWidget extends GetView<TrackController> {
  const BottomSheetBodyWidget({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
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
          controller: TextEditingController(),
        ),

        SizedBox(height: 10),

        CustomLocationInputField(
          icon: AppImages.flag,
          hintText: "To",
          controller: TextEditingController(),
        ),
      ],
    );
  }
}

class BottomSheetCardWidget extends StatelessWidget {
  const BottomSheetCardWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: child,
    );
  }
}
