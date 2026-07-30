import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/fonts.dart';
import '../../../../core/widgets/custom_drop_down.dart';
import '../controller/request_services_controller.dart';

class SelectServiceType extends GetView<RequestServicesController> {
  const SelectServiceType({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text("How I can Help you?", style: AppFonts.style15),
        CustomDropDown(
          hintText: "Select your Service Type",
          selectedValue: controller.selectedValue.value,
          values: controller.services,
          onChanged: (value) {
            controller.selectValue(value!);
          },
        ),
      ],
    );
  }
}
