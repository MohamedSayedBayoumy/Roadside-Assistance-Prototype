import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widgets/custom_image.dart';

class MapIconWidget extends StatelessWidget {
  const MapIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      delay: Duration(milliseconds: 600),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(bottom: 40.0),
          child: CustomImage(
            path: AppImages.mapMarker,
            width: 40,
            color: AppColors.mainColor,
          ),
        ),
      ),
    );
  }
}
