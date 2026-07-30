import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/app_utils.dart';
import '../../../../core/error/common_failed_model.dart';
import '../login_entity/login_entity_body.dart';
import '../login_repo/login_repo.dart';

class LoginUseCase {
  final LoginRepo loginRepo;
  LoginUseCase({required this.loginRepo});

  Future<Either<CommonFailedModel, dynamic>> login({
    required LoginEntityBody body,
  }) async {
    final emailError = AppUtils.validateEmail(body.user);
    final passwordError = AppUtils.validatePassword(body.password);

    final errors = [emailError, passwordError].whereType<String>().toList();

    var dioFailure = DioFailure(
      modelException: DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
      ),
      failureMessage: errors.join('\n'),
    );

    if (errors.isNotEmpty) {
      return Left(dioFailure);
    } else {
      return Right(true);
    }
    // return await loginRepo.login(body: body);
  }
}
