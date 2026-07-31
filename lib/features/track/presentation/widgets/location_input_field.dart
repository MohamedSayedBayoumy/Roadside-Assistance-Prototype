import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/images.dart';
import '../../../../routes/paths.dart';
import '../controller/track_controller.dart';

class CustomLocationInputField extends StatefulWidget {
  final String icon;
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Color iconColor;
  final TrackController trackingScrollController;

  const CustomLocationInputField({
    super.key,
    required this.icon,
    required this.controller,
    this.labelText = 'To',
    this.hintText = '',
    this.iconColor = Colors.white,
    required this.trackingScrollController,
  });

  @override
  State<CustomLocationInputField> createState() =>
      _CustomLocationInputFieldState();
}

class _CustomLocationInputFieldState extends State<CustomLocationInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: _isFocused ? AppColors.mainColor : Colors.black,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(widget.icon, width: 24),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.hintText,
                  style: const TextStyle(color: Colors.grey, fontSize: 14.0),
                ),
                TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode, // ربطنا الـ FocusNode هنا
                  style: AppFonts.style15,
                  cursorColor: AppColors.mainColor,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsetsDirectional.only(
                      top: 4.0,
                      bottom: 0,
                      end: 10,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          if (_isFocused) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: () async {
                await widget.trackingScrollController.saveCurrentMapState();
                Get.toNamed(AppPaths.pickLocation);
              },
              child: FadeIn(
                duration: Duration(seconds: 1),
                child: Image.asset(AppImages.location, width: 30),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
