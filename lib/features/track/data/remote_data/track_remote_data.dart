import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/common_failed_model.dart';
import '../../../../core/network/dio_services.dart';
import '../../../../core/services/ffi_services.dart';
import '../../domain/entity/latlong.dart';
import '../models/direction_model.dart';

abstract class TrackRemoteData {
  Future<Either<CommonFailedModel, DirectionModel>> getWay({
    required Latlong startPoint,
    required Latlong endPoint,
  });
}

class TrackRemoteDataImpel implements TrackRemoteData {
  final DioServices dioServices;

  TrackRemoteDataImpel(this.dioServices);
  @override
  Future<Either<CommonFailedModel, DirectionModel>> getWay({
    required Latlong startPoint,
    required Latlong endPoint,
  }) async {
    try {
      final response = await dioServices.get(
        path:
            "driving-traffi/${startPoint.long},${startPoint.lat};${endPoint.long},${endPoint.lat}",
        queryParameters: {
          "access_token": FFIHelper.fetchStringFromC(),
          "overview": "full",
        },
      );

      return Right(DirectionModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(DioFailure.fromDioException(dioType: e.type, exception: e));
    }
  }
}
