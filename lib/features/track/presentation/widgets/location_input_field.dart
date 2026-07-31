import 'package:flutter/material.dart';

import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/images.dart';

class CustomLocationInputField extends StatelessWidget {
  final String icon;
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Color iconColor;

  const CustomLocationInputField({
    super.key,
    required this.icon,
    required this.controller,
    this.labelText = 'To',
    this.hintText = '',
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(icon, width: 24),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hintText,
                  style: const TextStyle(color: Colors.grey, fontSize: 14.0),
                ),
                TextFormField(
                  controller: controller,
                  style: AppFonts.style12,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.only(top: 4.0, bottom: 0),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(AppImages.location, width: 30),
        ],
      ),
    );
  }
}
