import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_padding.dart';
import 'controller/request_services_controller.dart';
import 'widgets/select_service_type_section.dart';

class RequestServicesScreen extends GetView<RequestServicesController> {
  const RequestServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: SelectServiceType()),

            Obx(() {
              if (controller.selectedValue.value.isNotEmpty) {
                return FadeIn(
                  child: CustomButton(text: "Confirm", onPressed: () {}),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
