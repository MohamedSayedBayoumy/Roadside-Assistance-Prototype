import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../core/constants/fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeIn(child: Text("Loading...", style: AppFonts.styleLight25)),
      ),
    );
  }
}
