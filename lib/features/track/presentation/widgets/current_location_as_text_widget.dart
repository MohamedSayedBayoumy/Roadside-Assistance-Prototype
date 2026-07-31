import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/custom_loading.dart';
import '../controller/track_controller.dart';

class CurrentLocationAsTextWidget extends StatelessWidget {
  const CurrentLocationAsTextWidget({super.key, required this.controller});

  final TrackController controller;

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      delay: Duration(milliseconds: 400),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(bottom: 140),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Obx(
              () => controller.isFetchingAddress.value
                  ? CustomLoading()
                  : Text(
                      controller.selectLocation.value.controller.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
