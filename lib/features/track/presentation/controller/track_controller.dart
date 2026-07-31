import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:freelance/core/constants/colors.dart';
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
  PolylineAnnotationManager? _polyLineAnnotationManager;

  final fromPoint = PointModel(controller: TextEditingController()).obs;
  final toPoint = PointModel(controller: TextEditingController()).obs;
  final selectLocation = PointModel(controller: TextEditingController()).obs;

  final DraggableScrollableController sheetController =
      DraggableScrollableController();

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

      await _pointAnnotationManager!.deleteAll();

      final options = PointAnnotationOptions(
        geometry: Point(coordinates: mapbox.Position(point.long!, point.lat!)),
        image: MapServices.icon,
        iconSize: 0.25,
      );

      await _pointAnnotationManager!.create(options).whenComplete(() async {
        minimizeSheet();
        await zoomToFitTwoPoints(fromPoint.value, point);
      });
    } catch (e) {
      debugPrint("Error adding custom marker: $e");
    }
  }

  Future<void> zoomToFitTwoPoints(PointModel p1, PointModel p2) async {
    if (mapboxMap == null) return;

    try {
      double minLat = math.min(p1.lat!, p2.lat!);
      double maxLat = math.max(p1.lat!, p2.lat!);
      double minLng = math.min(p1.long!, p2.long!);
      double maxLng = math.max(p1.long!, p2.long!);

      final bounds = CoordinateBounds(
        southwest: Point(coordinates: mapbox.Position(minLng, minLat)),
        northeast: Point(coordinates: mapbox.Position(maxLng, maxLat)),
        infiniteBounds: false,
      );

      final cameraOptions = await mapboxMap!.cameraForCoordinateBounds(
        bounds,
        MbxEdgeInsets(top: 100, left: 50, bottom: 450, right: 50),
        null,
        null,
        null,
        null,
      );

      await mapboxMap!.flyTo(
        cameraOptions,
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );
    } catch (e) {
      debugPrint("Error zooming to fit points: $e");
    }
  }

  Future<void> drawLineBetweenTwoPoints(PointModel p1, PointModel p2) async {
    if (mapboxMap == null) return;

    try {
      _polyLineAnnotationManager ??= await mapboxMap!.annotations
          .createPolylineAnnotationManager();

      await _pointAnnotationManager!.deleteAll();

      final lineOptions = PolylineAnnotationOptions(
        geometry: LineString(
          coordinates: [
            mapbox.Position(p1.long!, p1.lat!),
            mapbox.Position(p2.long!, p2.lat!),
          ],
        ),
        lineColor: AppColors.mainColor.toARGB32(),
        lineWidth: 5.0,
        lineJoin: LineJoin.ROUND,
      );

      await _polyLineAnnotationManager!.create(lineOptions);
    } catch (e) {
      debugPrint("Error drawing line: $e");
    }
  }

  void minimizeSheet() {
    if (sheetController.isAttached) {
      sheetController.animateTo(
        0.22,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
