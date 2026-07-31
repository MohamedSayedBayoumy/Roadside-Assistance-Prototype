class DirectionEntity {
  final String? code;
  final List<WaypointEntity>? waypoints;
  final List<RouteEntity>? routes;
  final String? uuid;

  DirectionEntity({this.code, this.waypoints, this.routes, this.uuid});
}

class WaypointEntity {
  final List<double>? location;
  final String? name;
  final double? distance;

  WaypointEntity({this.location, this.name, this.distance});
}

class RouteEntity {
  final String? geometry;
  final double? distance;
  final double? duration;
  final List<LegEntity>? legs;

  RouteEntity({this.geometry, this.distance, this.duration, this.legs});
}

class LegEntity {
  final String? summary;
  final double? distance;
  final double? duration;

  LegEntity({this.summary, this.distance, this.duration});
}
