import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';
import 'custom_loading.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? CustomLoading(isMainColor: false)
            : Text(text, style: AppFonts.style15.copyWith(color: Colors.white)),
      ),
    );
  }
}
