import 'package:dartz/dartz.dart';

import '../../../../core/error/common_failed_model.dart';
import '../../domain/login_entity/login_entity_body.dart';
import '../../domain/login_repo/login_repo.dart';

class LoginDataRepos extends LoginRepo {
  // Here will be inject with Data Source

  @override
  Future<Either<CommonFailedModel, dynamic>> login({
    required LoginEntityBody body,
  }) {
    throw UnimplementedError();
  }
}
