import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/custom_button.dart';
import '../controller/track_controller.dart';

class FooterPickLocationWidget extends StatelessWidget {
  const FooterPickLocationWidget({super.key, required this.controller});

  final TrackController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IgnorePointer(
        ignoring: controller.isFetchingAddress.value,
        child: Opacity(
          opacity: controller.isFetchingAddress.value ? .7 : 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(Icons.arrow_back_ios_new_rounded, size: 25),
                ),
              ),

              Expanded(
                child: CustomButton(
                  text: "Confirm",
                  onPressed: () {
                    Get.back(result: controller.selectLocation);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
