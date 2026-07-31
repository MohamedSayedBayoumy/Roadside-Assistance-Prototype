import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Position;

import '../../../../core/services/location_permission_services.dart';

class TrackController extends GetxController {
  RxBool isLayoutReady = false.obs;
  MapboxMap? mapboxMap;

  RxString selectedAddress = ''.obs;
  TextEditingController fromSearchController = TextEditingController();
  TextEditingController toSearchController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    isLayoutReady.value = true;
  }

  void onMapCreated(MapboxMap controller, BuildContext context) {
    mapboxMap = controller;

    mapboxMap!.location.updateSettings(
      LocationComponentSettings(enabled: true, pulsingEnabled: true),
    );

    getUserPosition(context);
  }

  Future<void> getUserPosition(BuildContext context) async {
    bool serviceEnabled =
        await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    bool hasPermission =
        await LocationPermissionServices.requestLocationPermission();
    if (!hasPermission) return;

    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition();

    getMyLocationAsString(position);

    await Future.delayed(const Duration(milliseconds: 1500));

    mapboxMap?.flyTo(
      CameraOptions(
        center: Point(
          coordinates: mapbox.Position(position.longitude, position.latitude),
        ),
        zoom: 15.0,
        pitch: 45.0,
      ),
      MapAnimationOptions(duration: 2500, startDelay: 0),
    );
  }

  Future<String?> getMyLocationAsString(Position position) async {
    try {
      final placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placeMarks.isEmpty) {
        return '${position.latitude}, ${position.longitude}';
      }
      final p = placeMarks.first;

      final parts = <String>[
        p.subLocality ?? '',
        p.locality ?? p.country ?? '',
      ].where((e) => e.trim().isNotEmpty).toList();
      if (parts.isEmpty) {
        return '${position.latitude}, ${position.longitude}';
      }

      fromSearchController.text = parts.join(' , ');
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<void> updateAddressFromCenter() async {
    log("message");
    if (mapboxMap == null) return;
    try {
      final cameraState = await mapboxMap!.getCameraState();
      final lng = cameraState.center.coordinates.lng as double;
      final lat = cameraState.center.coordinates.lat as double;

      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        selectedAddress.value =
            "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}"
                .replaceAll(RegExp(r'^, |, $'), '')
                .replaceAll(', , ', ', ');
      }
    } catch (e) {
      selectedAddress.value = "تعذر تحديد الموقع";
    }
  }

  // Future<void> searchAddress() async {
  //   if (searchController.text.trim().isEmpty) return;
  //   FocusManager.instance.primaryFocus?.unfocus();

  //   try {
  //     List<Location> locations = await locationFromAddress(
  //       searchController.text,
  //     );
  //     if (locations.isNotEmpty) {
  //       final lat = locations.first.latitude;
  //       final lng = locations.first.longitude;

  //       mapboxMap?.flyTo(
  //         CameraOptions(
  //           center: Point(coordinates: mapbox.Position(lng, lat)),
  //           zoom: 15.0,
  //           pitch: 0.0,
  //         ),
  //         MapAnimationOptions(duration: 1500, startDelay: 0),
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       "تنبيه",
  //       "لم يتم العثور على المكان، حاول كتابة الاسم بشكل أدق",
  //     );
  //   }
  // }

  @override
  void onClose() {
    fromSearchController.dispose();
    toSearchController.dispose();
    super.onClose();
  }
}
