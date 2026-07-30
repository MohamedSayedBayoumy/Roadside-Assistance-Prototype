import 'package:flutter/material.dart';

import '../../../../core/constants/fonts.dart';

class HeaderTextWidget extends StatelessWidget {
  const HeaderTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Log in", style: AppFonts.styleLight25),

        RichText(
          text: TextSpan(
            style: AppFonts.style15,
            children: [
              TextSpan(
                text: "By logging in, you agree to our ",
                style: AppFonts.style15.copyWith(color: Colors.grey),
              ),
              TextSpan(
                text: "Terms of Use.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
