import 'package:flutter/material.dart';

import '../controller/track_controller.dart';
import 'bottom_sheet_body_widget.dart';
import 'bottom_sheet_card_widget.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key, required this.controller});

  final TrackController controller;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return BottomSheetCardWidget(
          child: BottomSheetBodyWidget(scrollController: scrollController),
        );
      },
    );
  }
}
