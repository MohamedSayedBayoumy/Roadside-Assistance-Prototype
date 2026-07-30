import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';

class OpenSettingWidget extends StatelessWidget {
  const OpenSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_off_rounded,
            size: 60,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 16),
          Text("Location Permission Required", style: AppFonts.style15),
          const SizedBox(height: 12),
          Text(
            "To accurately locate you and dispatch the nearest roadside assistance, please enable location permissions for the app in your device settings.",
            textAlign: TextAlign.center,
            style: AppFonts.style15,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text(
                "Open Setting",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
