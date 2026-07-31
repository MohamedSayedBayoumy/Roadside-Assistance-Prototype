import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/images.dart';
import '../../../../routes/paths.dart';
import '../../domain/entity/point_model.dart';
import '../controller/track_controller.dart';

class CustomLocationInputField extends StatelessWidget {
  final String icon;
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Color iconColor;
  final TrackController trackingScrollController;
  final Function(Rx<PointModel>)? callBackWithAddress;
  final bool showPickIcon;

  const CustomLocationInputField({
    super.key,
    required this.icon,
    required this.controller,
    this.labelText = 'To',
    this.hintText = '',
    this.iconColor = Colors.white,
    this.callBackWithAddress,
    this.showPickIcon = true,
    required this.trackingScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.mainColor),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () async {
          if (showPickIcon == true &&
              trackingScrollController.isTripActive.value == false) {
            await trackingScrollController.saveCurrentMapState();
            final address = await Get.toNamed(AppPaths.pickLocation);
            callBackWithAddress!(address!);
          }
        },
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
                  IgnorePointer(
                    ignoring: true,
                    child: TextFormField(
                      controller: controller,
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
                  ),
                ],
              ),
            ),
            if (showPickIcon == true) ...[
              const SizedBox(width: 8),
              ZoomIn(
                duration: Duration(seconds: 1),
                child: Image.asset(AppImages.location, width: 30),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
