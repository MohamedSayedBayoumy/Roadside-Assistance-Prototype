import 'package:dartz/dartz.dart';

import '../../../../core/error/common_failed_model.dart';
import '../entity/direction_entity.dart';
import '../entity/latlong.dart';
import '../repos/track_repos.dart';

class TrackUseCase {
  final TrackRepos trackRepos;
  TrackUseCase({required this.trackRepos});

  Future<Either<CommonFailedModel, DirectionEntity>> getDirections({
    required Latlong startPoint,
    required Latlong endPoint,
  }) async {
    return await trackRepos.getDirections(startPoint: startPoint, endPoint: endPoint);
  }
}
