import '../../domain/entity/direction_entity.dart';

class DirectionModel extends DirectionEntity {
  DirectionModel({super.code, super.waypoints, super.routes, super.uuid});

  factory DirectionModel.fromJson(Map<String, dynamic> json) {
    return DirectionModel(
      code: json['code'] as String?,
      waypoints: (json['waypoints'] as List<dynamic>?)
          ?.map((e) => WaypointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      routes: (json['routes'] as List<dynamic>?)
          ?.map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      uuid: json['uuid'] as String?,
    );
  }
}

class WaypointModel extends WaypointEntity {
  WaypointModel({super.location, super.name, super.distance});

  factory WaypointModel.fromJson(Map<String, dynamic> json) {
    return WaypointModel(
      location: (json['location'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      name: json['name'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
    );
  }
}

class RouteModel extends RouteEntity {
  RouteModel({super.geometry, super.distance, super.duration, super.legs});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      geometry: json['geometry'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      duration: (json['duration'] as num?)?.toDouble(),
      legs: (json['legs'] as List<dynamic>?)
          ?.map((e) => LegModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class LegModel extends LegEntity {
  LegModel({super.summary, super.distance, super.duration});

  factory LegModel.fromJson(Map<String, dynamic> json) {
    return LegModel(
      summary: json['summary'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      duration: (json['duration'] as num?)?.toDouble(),
    );
  }
}
