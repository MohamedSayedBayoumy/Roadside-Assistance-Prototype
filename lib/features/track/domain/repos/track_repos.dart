import 'package:dartz/dartz.dart';

import '../../../../core/error/common_failed_model.dart';
import '../entity/direction_entity.dart';
import '../entity/latlong.dart';

abstract class TrackRepos {
  Future<Either<CommonFailedModel, DirectionEntity>> getDirections({
    required Latlong startPoint,
    required Latlong endPoint,
  });
}
