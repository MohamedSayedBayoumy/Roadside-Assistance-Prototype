import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';
import 'text_field_widget.dart';

class LoginFormWidget extends GetView<LoginController> {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        spacing: 10,
        children: [
          TextFieldWidget(
            hintText: "Your Email",
            controller: controller.emailController,
          ),
          TextFieldWidget(
            hintText: "Your Password",
            isPasswordField: true,
            controller: controller.passwordController,
          ),
        ],
      ),
    );
  }
}
