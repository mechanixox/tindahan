import 'package:flutter/material.dart';
import 'package:plantdemic/screens/search_screen.dart';
import 'package:plantdemic/widgets/subtitle_text.dart';
import 'package:plantdemic/widgets/title_text.dart';

class EmptyBagWidget extends StatelessWidget {
  final String imagePath, title, subtitle, buttonText;
  const EmptyBagWidget(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: size.height * 0.30,
            width: double.infinity,
          ),
          SizedBox(
            height: 20,
          ),
          TitlesTextWidget(
            label: title,
            fontSize: 20,
            color: Colors.red,
          ),
          SubtitleTextWidget(
            label: subtitle,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          SizedBox(
            height: 80,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12)),
              onPressed: () {
                Navigator.of(context).pushNamed(SearchScreen.routeName);
              },
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 16,
                ),
              ))
        ],
      ),
    ));
  }
}
