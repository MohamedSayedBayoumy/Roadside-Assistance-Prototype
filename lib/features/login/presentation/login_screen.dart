import 'package:flutter/material.dart';

import '../../../core/widgets/custom_padding.dart';
import 'widgets/footer_login_widget.dart';
import 'widgets/header_text_widget.dart';
import 'widgets/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 50,
          children: [
            HeaderTextWidget(),
            LoginFormWidget(),
            FooterLoginWidget(),
          ],
        ),
      ),
    );
  }
}
