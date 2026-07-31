import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Position;

import '../../../../core/constants/colors.dart';
import '../../../../core/enums/screen_state.dart';
import '../../../../core/services/map_services.dart';
import '../../domain/entity/latlong.dart';
import '../../domain/entity/point_model.dart';
import '../../domain/use_case/track_use_case.dart';

class TrackController extends GetxController {
  final TrackUseCase trackUseCase;

  TrackController({required this.trackUseCase});
  RxBool isLayoutReady = false.obs;
  MapboxMap? mapboxMap;

  PointAnnotationManager? _pointAnnotationManager;
  mapbox.PolylineAnnotationManager? _polylineAnnotationManager;
  mapbox.PolylineAnnotation? _animatedPolyline;
  Timer? _animationTimer;

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

  final getDirectionsState = ScreenState.initial.obs;

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

      await _pointAnnotationManager!.create(options);
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

  void minimizeSheet() {
    if (sheetController.isAttached) {
      sheetController.animateTo(
        0.22,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> drawAnimatedRoute(String geometry) async {
    if (mapboxMap == null) return;

    try {
      List<PointLatLng> result = PolylinePoints.decodePolyline(geometry);
      List<mapbox.Position> allCoordinates = result.map((point) {
        return mapbox.Position(point.longitude, point.latitude);
      }).toList();

      if (allCoordinates.length < 2) return;

      _polylineAnnotationManager ??= await mapboxMap!.annotations
          .createPolylineAnnotationManager();

      await _polylineAnnotationManager!.deleteAll();
      _animationTimer?.cancel();

      List<mapbox.Position> currentCoordinates = [
        allCoordinates[0],
        allCoordinates[1],
      ];

      var polylineOptions = mapbox.PolylineAnnotationOptions(
        geometry: mapbox.LineString(coordinates: currentCoordinates),
        lineColor: AppColors.mainColor.toARGB32(),
        lineWidth: 5.0,
        lineJoin: mapbox.LineJoin.ROUND,
      );

      _animatedPolyline = await _polylineAnnotationManager!.create(
        polylineOptions,
      );

      int currentIndex = 2;

      _animationTimer = Timer.periodic(const Duration(milliseconds: 30), (
        timer,
      ) async {
        if (currentIndex >= allCoordinates.length) {
          timer.cancel();
          return;
        }

        currentCoordinates.add(allCoordinates[currentIndex]);
        currentIndex++;

        if (_animatedPolyline != null) {
          _animatedPolyline!.geometry = mapbox.LineString(
            coordinates: currentCoordinates,
          );
          await _polylineAnnotationManager!.update(_animatedPolyline!);
        }
      });

      debugPrint("Animated route started successfully!");
    } catch (e) {
      debugPrint("Error drawing animated route: $e");
    }
  }

  Future<void> animateToLocation({
    PointModel? point,
    double zoom = 3.0,
    int durationMillis = 1500,
  }) async {
    if (mapboxMap == null) return;

    try {
      mapboxMap?.flyTo(
        CameraOptions(
          center: Point(coordinates: mapbox.Position(0, 0)),
          zoom: 3.0,
          pitch: 45.0,
        ),
        MapAnimationOptions(duration: 2500, startDelay: 0),
      );
    } catch (e) {
      debugPrint("Error animating camera: $e");
    }
  }

  Future<void> getDirections({required PointModel point}) async {
    animateToLocation(zoom: 5);
    minimizeSheet();
    getDirectionsState.value = ScreenState.loading;

    final result = await trackUseCase.getDirections(
      startPoint: Latlong(
        lat: fromPoint.value.lat!,
        long: fromPoint.value.long!,
      ),
      endPoint: Latlong(lat: toPoint.value.lat!, long: toPoint.value.long!),
    );

    result.fold(
      (f) {
        animateToLocation(zoom: 15, point: fromPoint.value);

        getDirectionsState.value = ScreenState.failed;
      },
      (r) async {
        getDirectionsState.value = ScreenState.initial;
        zoomToFitTwoPoints(fromPoint.value, point);

        addNewMapIcon(point: point);

        drawAnimatedRoute(r.routes!.first.geometry!);
      },
    );
  }

  @override
  void onClose() {
    _debounce?.cancel();
    fromPoint.value.controller.dispose();
    toPoint.value.controller.dispose();
    super.onClose();
  }
}
