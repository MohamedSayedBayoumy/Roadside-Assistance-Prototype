import 'package:flutter_test/flutter_test.dart';
import 'package:freelance/core/error/common_failed_model.dart';
import 'package:freelance/features/login/domain/login_entity/login_entity_body.dart';
import 'package:freelance/features/login/domain/login_repo/login_repo.dart';
import 'package:freelance/features/login/domain/login_use_case/login_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepo extends Mock implements LoginRepo {}

void main() {
  late LoginUseCase loginUseCase;
  late MockLoginRepo mockLoginRepo;

  setUp(() {
    mockLoginRepo = MockLoginRepo();
    loginUseCase = LoginUseCase(loginRepo: mockLoginRepo);
  });

  group('LoginUseCase Validation Tests', () {
    test(
      'should return Left(DioFailure) when email and password are both invalid',
      () async {
        // Arrange
        final invalidBody = LoginEntityBody(
          user: 'invalid_email_format',
          password: '123',
        );

        final result = await loginUseCase.login(body: invalidBody);

        expect(result.isLeft(), true);

        result.fold((failure) {
          expect(failure, isA<DioFailure>());

          // expect((failure as DioFailure).failureMessage, isNotEmpty);
        }, (_) => fail('Should not return Right when inputs are invalid'));
      },
    );

    test('should return Right(true) when inputs are valid', () async {
      final validBody = LoginEntityBody(
        user: 'test@example.com',
        password: 'StrongPassword123!',
      );
      final result = await loginUseCase.login(body: validBody);

      expect(result.isRight(), true);

      result.fold((_) => fail('Should not return Left when inputs are valid'), (
        success,
      ) {
        expect(success, true);
      });
    });
  });
}
