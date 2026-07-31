import 'package:freelance/core/constants/app_keys.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

import '../../../../core/services/location_permission_services.dart';

import 'package:flutter/services.dart';

import '../constants/images.dart';
import 'hive_services.dart';

abstract class MapServices {
  static Uint8List? icon;
  static Future<geolocator.Position?> getCurrentLocation() async {
    bool serviceEnabled =
        await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    bool hasPermission =
        await LocationPermissionServices.requestLocationPermission();
    if (!hasPermission) return null;

    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition();

    return position;
  }

  static Future<String?> getLocationAsString(Position position) async {
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

      return parts.join(' , ');
    } catch (_) {
      return null;
    }
  }

  static Future<void> getOrAddCustomMarker() async {
    const String boxName = 'cache_box';

    Uint8List? cachedImageData = await HiveService.instance.getData<Uint8List>(
      boxName: boxName,
      key: AppKeys.mapIcon,
    );

    if (cachedImageData != null) {
      icon = cachedImageData;
    }

    final ByteData bytes = await rootBundle.load(AppImages.mapMarker);
    final Uint8List imageData = bytes.buffer.asUint8List();

    await HiveService.instance.saveData<Uint8List>(
      boxName: boxName,
      key: AppKeys.mapIcon,
      value: imageData,
    );

    icon = imageData;
  }
}

//  mapBox.PointAnnotationOptions options = mapBox.PointAnnotationOptions(
//       geometry: mapBox.Point(coordinates: mapBox.Position(31.2357, 30.0444)),
//       image: imageData,
//       iconSize: 1.0,
//     );

//     return options;
