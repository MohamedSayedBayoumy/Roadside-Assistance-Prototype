import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Position;

import '../../../../core/services/map_services.dart';
import '../../domain/entity/point_model.dart';

class TrackController extends GetxController {
  RxBool isLayoutReady = false.obs;
  MapboxMap? mapboxMap;

  PointAnnotationManager? _pointAnnotationManager;

  final fromPoint = PointModel(controller: TextEditingController()).obs;
  final toPoint = PointModel(controller: TextEditingController()).obs;
  final selectLocation = PointModel(controller: TextEditingController()).obs;

  Position? userPosition;

  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxBool isFetchingAddress = false.obs;

  Timer? _debounce;

  CameraState? savedCameraState;

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
    userPosition = await MapServices.getCurrentLocation();
    if (userPosition == null) return;

    String? address = await MapServices.getLocationAsString(userPosition!);
    if (address != null) {
      fromPoint.value.controller.text = address;
      fromPoint.value.lat = userPosition!.latitude;
      fromPoint.value.long = userPosition!.longitude;
    }

    await Future.delayed(const Duration(milliseconds: 500));
    mapboxMap?.flyTo(
      CameraOptions(
        center: Point(
          coordinates: mapbox.Position(
            userPosition!.longitude,
            userPosition!.latitude,
          ),
        ),
        zoom: 15.0,
        pitch: 45.0,
      ),
      MapAnimationOptions(duration: 2500, startDelay: 0),
    );
  }

  void onCameraMoved(CameraChangedEventData cameraChangedEventData) {
    latitude.value =
        cameraChangedEventData.cameraState.center.coordinates.lat as double;
    longitude.value =
        cameraChangedEventData.cameraState.center.coordinates.lng as double;

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    isFetchingAddress.value = true;

    _debounce = Timer(const Duration(milliseconds: 800), () {
      _fetchAddress(latitude.value, longitude.value);
    });
  }

  Future<void> _fetchAddress(double lat, double lng) async {
    try {
      Position currentCenterPos = Position(
        longitude: lng,
        latitude: lat,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );

      String? address = await MapServices.getLocationAsString(currentCenterPos);

      if (address != null && address.isNotEmpty) {
        selectLocation.value = PointModel(
          lat: latitude.value,
          long: longitude.value,
          controller: TextEditingController(text: address),
        );
      }
    } finally {
      isFetchingAddress.value = false;
    }
  }

  // void confirmPickedLocation() {
  //   if (selectedAddress.value.isNotEmpty) {
  //     toSearchController.text = selectedAddress.value;
  //   }
  // }

  Future<void> saveCurrentMapState() async {
    if (mapboxMap != null) {
      savedCameraState = await mapboxMap!.getCameraState();
    }
  }

  Future<void> addNewMapIcon({required PointModel point}) async {
    if (mapboxMap == null) return;

    try {
      _pointAnnotationManager ??= await mapboxMap!.annotations
          .createPointAnnotationManager();

      final options = PointAnnotationOptions(
        geometry: Point(coordinates: mapbox.Position(point.long!, point.lat!)),
        image: MapServices.icon,
        iconSize: 0.25,
      );

      await _pointAnnotationManager!.create(options);
    } catch (e) {
      debugPrint("Error adding custom marker: $e");
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    fromPoint.value.controller.dispose();
    toPoint.value.controller.dispose();
    super.onClose();
  }
}
