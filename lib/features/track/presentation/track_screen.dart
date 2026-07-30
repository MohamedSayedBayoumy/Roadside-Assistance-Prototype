import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/widgets/custom_loading.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isLayoutReady = true;
        });
      }
    });
  }

  bool _isLayoutReady = false;

  MapboxMap? mapboxMap;

  void _onMapCreated(MapboxMap controller) {
    mapboxMap = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLayoutReady
          ? MapWidget(
              key: const ValueKey("mapWidget"),
              onMapCreated: _onMapCreated,
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(31.2357, 30.0444)),
                zoom: 12.0,
                pitch: 45.0,
              ),
            )
          : CustomLoading(),
    );
  }
}
