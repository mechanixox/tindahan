import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:plantdemic/widgets/title_text.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({super.key, this.fontSize = 30});
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 22),
      baseColor: Color.fromARGB(255, 75, 109, 241), // Base color: 7CE495
      highlightColor:
          Color.fromARGB(255, 151, 232, 250), // Highlight color: CFF4D2
      child: TitlesTextWidget(
        label: "Tindahan",
        fontSize: fontSize,
      ),
    );
  }
}
