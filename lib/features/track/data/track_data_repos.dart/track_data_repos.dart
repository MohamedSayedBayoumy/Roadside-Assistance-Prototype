import 'package:dartz/dartz.dart';

import '../../../../core/error/common_failed_model.dart';
import '../../domain/entity/direction_entity.dart';
import '../../domain/entity/latlong.dart';
import '../../domain/repos/track_repos.dart';
import '../remote_data/track_remote_data.dart';

class TrackDataRepos extends TrackRepos {
  final TrackRemoteData trackRemoteData;

  TrackDataRepos({required this.trackRemoteData});

  @override
  Future<Either<CommonFailedModel, DirectionEntity>> getDirections({
    required Latlong startPoint,
    required Latlong endPoint,
  }) {
    return trackRemoteData.getWay(startPoint: startPoint, endPoint: endPoint);
  }
}
