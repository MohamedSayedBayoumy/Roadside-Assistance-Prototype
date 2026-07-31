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
import '../../domain/entity/direction_entity.dart';
import '../../domain/entity/latlong.dart';
import '../../domain/entity/point_model.dart';
import '../../domain/use_case/track_use_case.dart';

class TrackController extends GetxController {
  final TrackUseCase trackUseCase;

  TrackController({required this.trackUseCase});
  RxBool isLayoutReady = false.obs;
  MapboxMap? mapboxMap;
  DirectionEntity? directionEntity;

  PointAnnotationManager? _pointAnnotationManager;

  mapbox.PolylineAnnotationManager? _polylineAnnotationManager;
  mapbox.PolylineAnnotation? _animatedPolyline;
  Timer? _animationTimer;

  mapbox.PointAnnotationManager? _driverMarkerManager;
  mapbox.PointAnnotation? _driverMarker;

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

  Future<void> handleFromPoint() async {}

  Future<void> getDirections({required PointModel point}) async {
    if (_driverMarkerManager != null) {
      await mapboxMap!.location.updateSettings(
        LocationComponentSettings(enabled: true),
      );
      await _driverMarkerManager!.deleteAll();
      _driverMarker = null;
    }
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
        getDirectionsState.value = ScreenState.failed;
      },
      (r) async {
        getDirectionsState.value = ScreenState.initial;

        directionEntity = r;
        zoomToFitTwoPoints(fromPoint.value, point);

        addNewMapIcon(point: point);

        drawAnimatedRoute(r.routes!.first.geometry!);
      },
    );
  }

  double _calculateBearing(mapbox.Position start, mapbox.Position end) {
    double lat1 = start.lat * math.pi / 180.0;
    double lng1 = start.lng * math.pi / 180.0;
    double lat2 = end.lat * math.pi / 180.0;
    double lng2 = end.lng * math.pi / 180.0;

    double dLng = lng2 - lng1;

    double y = math.sin(dLng) * math.cos(lat2);
    double x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);

    double bearing = math.atan2(y, x);
    return (bearing * 180.0 / math.pi + 360.0) % 360.0;
  }

  Timer? _frameTimer;
  Future<void> _animateCarBetween(
    mapbox.Position start,
    mapbox.Position end,
    int durationMillis,
    List<mapbox.Position> remainingRoute, // <-- ضفنا المتغير ده هنا
  ) async {
    Completer<void> completer = Completer();

    int frameRate = 16;
    int totalFrames = durationMillis ~/ frameRate;
    int currentFrame = 0;

    double bearing = _calculateBearing(start, end);

    if (_driverMarker != null) {
      _driverMarker!.iconRotate = bearing;
    }

    _frameTimer?.cancel();
    _frameTimer = Timer.periodic(Duration(milliseconds: frameRate), (
      timer,
    ) async {
      currentFrame++;
      double t = currentFrame / totalFrames;

      if (t >= 1.0) {
        t = 1.0;
        timer.cancel();
        completer.complete();
      }

      double interpolatedLat = start.lat + ((end.lat - start.lat) * t);
      double interpolatedLng = start.lng + ((end.lng - start.lng) * t);

      mapbox.Position newPosition = mapbox.Position(
        interpolatedLng,
        interpolatedLat,
      );

      if (_driverMarker != null) {
        _driverMarker!.geometry = mapbox.Point(coordinates: newPosition);
        await _driverMarkerManager!.update(_driverMarker!);
      }

      if (_animatedPolyline != null && _polylineAnnotationManager != null) {
        List<mapbox.Position> updatedLine = [newPosition, ...remainingRoute];

        _animatedPolyline!.geometry = mapbox.LineString(
          coordinates: updatedLine,
        );
        await _polylineAnnotationManager!.update(_animatedPolyline!);
      }
    });

    return completer.future;
  }

  bool _isSimulationRunning = false;
  Future<void> startSmoothDriverSimulation() async {
    if (mapboxMap == null) return;
    _isSimulationRunning = true;

    try {
      await mapboxMap!.location.updateSettings(
        LocationComponentSettings(enabled: false),
      );
      _animationTimer?.cancel();

      List<PointLatLng> result = PolylinePoints.decodePolyline(
        directionEntity!.routes!.first.geometry!,
      );
      List<mapbox.Position> routeCoordinates = result.map((point) {
        return mapbox.Position(point.longitude, point.latitude);
      }).toList();

      if (routeCoordinates.isEmpty) return;

      _driverMarkerManager ??= await mapboxMap!.annotations
          .createPointAnnotationManager();
      await _driverMarkerManager!.deleteAll();

      var initialPointOptions = mapbox.PointAnnotationOptions(
        geometry: mapbox.Point(coordinates: routeCoordinates.first),
        image: MapServices.carIcon,
        iconSize: .3,
      );

      _driverMarker = await _driverMarkerManager!.create(initialPointOptions);

      for (int i = 0; i < routeCoordinates.length - 1; i++) {
        if (!_isSimulationRunning) break;

        mapbox.Position start = routeCoordinates[i];
        mapbox.Position end = routeCoordinates[i + 1];

        List<mapbox.Position> remainingRoute = routeCoordinates.sublist(i + 1);

        mapboxMap!.easeTo(
          mapbox.CameraOptions(
            center: mapbox.Point(coordinates: end),
            zoom: 14.0,
          ),
          mapbox.MapAnimationOptions(duration: 1000),
        );

        await _animateCarBetween(start, end, 1000, remainingRoute);
      }

      debugPrint("Driver reached the destination smoothly!");
    } catch (e) {
      debugPrint("Error in smooth driver simulation: $e");
    }
  }

  void stopSimulation() {
    _isSimulationRunning = false;
    _frameTimer?.cancel();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    fromPoint.value.controller.dispose();
    toPoint.value.controller.dispose();
    super.onClose();
  }
}
