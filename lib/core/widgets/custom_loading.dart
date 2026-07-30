import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key, this.isMainColor = true});
  final bool isMainColor;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      backgroundColor: isMainColor ? AppColors.mainColor : Colors.white,
    );
  }
}
