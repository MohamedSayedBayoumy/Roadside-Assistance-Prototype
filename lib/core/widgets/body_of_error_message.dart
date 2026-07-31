import 'package:flutter/material.dart';

import '../app_utils.dart';
import '../constants/fonts.dart';

class BodyOfErrorMessageWidget extends StatelessWidget {
  const BodyOfErrorMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Unstable internet connection",
                  style: AppFonts.style18.copyWith(color: Colors.white),
                ),

                Text(
                  "The app might be slower than usual",
                  style: AppFonts.style15.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () {
              ScaffoldMessenger.of(
                AppUtils.navigatorKey.currentContext!,
              ).hideCurrentSnackBar();
            },
          ),
        ],
      ),
    );
  }
}
