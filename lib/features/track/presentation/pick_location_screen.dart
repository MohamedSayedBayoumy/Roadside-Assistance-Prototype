import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:freelance/core/constants/colors.dart';
import 'package:freelance/core/constants/images.dart';
import 'package:freelance/core/widgets/custom_image.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

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

            onMapCreated: (mapController) =>
                controller.onMapCreated(mapController, context),

            onCameraChangeListener: (cameraChangedEventData) {
              final lat =
                  cameraChangedEventData.cameraState.center.coordinates.lat
                      as double;
              final lng =
                  cameraChangedEventData.cameraState.center.coordinates.lng
                      as double;

              controller.onCameraMoved(lat, lng);
            },

            cameraOptions: CameraOptions(zoom: 14.0, pitch: 0.0),
          ),

          ZoomIn(
            delay: Duration(seconds: 1),
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
          ),

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
