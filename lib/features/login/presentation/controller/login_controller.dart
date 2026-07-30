import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/screen_state.dart';
import '../../../../core/services/toasts.dart';
import '../../domain/login_entity/login_entity_body.dart';
import '../../domain/login_use_case/login_use_case.dart';

class LoginController extends GetxController {
  final LoginUseCase loginUseCase;

  LoginController(this.loginUseCase);

  @override
  void onInit() {
    super.onInit();
    listenerScreenState();
  }

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final screenState = ScreenState.initial.obs;

  String errorMessage = "";

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    screenState.value = ScreenState.loading;

    final authEntity = LoginEntityBody(
      user: emailController.text.trim(),
      password: passwordController.text,
    );

    final result = await loginUseCase.login(body: authEntity);
    Future.delayed(Duration(seconds: 2), () {
      result.fold(
        (failure) {
          errorMessage = failure.failureMessage!;
          screenState.value = ScreenState.failed;
        },
        (user) {
          screenState.value = ScreenState.loaded;
        },
      );
    });
  }

  Worker listenerScreenState() {
    return ever(screenState, (state) {
      switch (state) {
        case ScreenState.loaded:
          AppToast.success(description: "You have logged in successfully");
          break;

        case ScreenState.failed:
          AppToast.failed(description: errorMessage);
          break;

        case ScreenState.initial:
        case ScreenState.loading:
          break;
      }
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
