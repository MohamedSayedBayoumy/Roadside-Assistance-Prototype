import 'package:dartz/dartz.dart';

import '../../../../core/error/common_failed_model.dart';
import '../login_entity/login_entity_body.dart';

abstract class LoginRepo {
  Future<Either<CommonFailedModel, dynamic>> login({
    required LoginEntityBody body,
  });
}
