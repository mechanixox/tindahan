import 'package:flutter/material.dart';
import 'package:plantdemic/widgets/title_text.dart';

import '../widgets/subtitle_text.dart';
import 'assets_manager.dart';

class MyAppFunctions {
  static Future<void> showErrorOrWarningDialog({
    required BuildContext context,
    required String subtitle,
    bool isError = true,
    required Function fct,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Image.asset(
                isError ? AssetsManager.error : AssetsManager.warning,
                height: 60,
                width: 60,
              ),
              const SizedBox(
                height: 16.0,
              ),
              SubtitleTextWidget(
                label: subtitle,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
              const SizedBox(
                height: 26.0,
              ),
              Visibility(
                visible: !isError,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const SubtitleTextWidget(
                    label: "Cancel",
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  fct();
                  Navigator.pop(context);
                },
                child: const SubtitleTextWidget(
                  label: "Okay",
                  color: Colors.red, // Adjust color for error
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFCT,
    required Function galleryFCT,
    required Function removeFCT,
  }) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: TitlesTextWidget(
                label: "Choose option",
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      cameraFCT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("Camera"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      galleryFCT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.browse_gallery,
                    ),
                    label: const Text("Gallery"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      removeFCT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline,
                    ),
                    label: const Text("Remove"),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
