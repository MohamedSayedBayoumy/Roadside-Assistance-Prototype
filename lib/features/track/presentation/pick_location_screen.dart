// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/images.dart';
import '../../../core/widgets/custom_image.dart';
import '../../../core/widgets/custom_loading.dart';
import 'controller/track_controller.dart';
import 'widgets/footer_pick_location_widget.dart';

class LocationPickerScreen extends GetView<TrackController> {
  const LocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey("mapWidget"),

            onMapCreated: (_) => controller.onMapCreated,

            cameraOptions: controller.savedCameraState != null
                ? CameraOptions(
                    center: controller.savedCameraState!.center,
                    zoom: controller.savedCameraState!.zoom,
                    bearing: controller.savedCameraState!.bearing,
                    pitch: controller.savedCameraState!.pitch,
                  )
                : CameraOptions(
                    center: Point(coordinates: Position(30.0444, 31.2357)),
                    zoom: 12.0,
                  ),

            onCameraChangeListener: (cameraChangedEventData) {
              controller.onCameraMoved(cameraChangedEventData);
            },
          ),

          MapIconWidget(),

          CurrentLocationAsTextWidget(controller: controller),

          Positioned(
            bottom: 30,
            left: 15,
            right: 15,
            child: FooterPickLocationWidget(controller: controller),
          ),
        ],
      ),
    );
  }
}

class CurrentLocationAsTextWidget extends StatelessWidget {
  const CurrentLocationAsTextWidget({super.key, required this.controller});

  final TrackController controller;

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      delay: Duration(milliseconds: 400),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(bottom: 140),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Obx(
              () => controller.isFetchingAddress.value
                  ? CustomLoading()
                  : Text(controller.selectedAddress.value),
            ),
          ),
        ),
      ),
    );
  }
}

class MapIconWidget extends StatelessWidget {
  const MapIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      delay: Duration(milliseconds: 600),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(bottom: 40.0),
          child: CustomImage(
            path: AppImages.mapMarker,
            width: 40,
            color: AppColors.mainColor,
          ),
        ),
      ),
    );
  }
}
