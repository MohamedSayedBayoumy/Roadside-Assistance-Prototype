import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/screen_state.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controller/login_controller.dart';

class FooterLoginWidget extends GetView<LoginController> {
  const FooterLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const Text(
          "We will send you an e-mail with a login link.",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Obx(
          () => CustomButton(
            isLoading: controller.screenState.value == ScreenState.loading,
            text: "Connect",
            onPressed: () {
              controller.login();
            },
          ),
        ),
      ],
    );
  }
}
