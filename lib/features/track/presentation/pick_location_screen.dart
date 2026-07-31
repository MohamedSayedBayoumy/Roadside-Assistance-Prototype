// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'controller/track_controller.dart';
import 'widgets/current_location_as_text_widget.dart';
import 'widgets/footer_pick_location_widget.dart';
import 'widgets/map_icon_widget.dart';

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
