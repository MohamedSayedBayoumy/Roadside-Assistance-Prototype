import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:async';
import 'dart:ui';
// import 'package:geolocator/geolocator.dart';

Future initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'location_tracking',
      initialNotificationTitle: 'Location Tracking',
      initialNotificationContent: 'Running in background',
      // foregroundServiceType: AndroidForegroundType.location,
    ),
    iosConfiguration: IosConfiguration(autoStart: false, onForeground: onStart),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // service.on('stopService').listen((event) {
  //   service.stopSelf();
  // });

  // Geolocator.getPositionStream(
  //   locationSettings: const LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //     distanceFilter: 10,
  //   ),
  // ).listen((Position position) {
  //   print('Background Location: ${position.latitude}, ${position.longitude}');

  //   service.invoke('updateLocation', {
  //     'lat': position.latitude,
  //     'lng': position.longitude,
  //   });
  // });
}
