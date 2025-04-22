import 'package:flutter/material.dart';
import 'package:ulmo/core/utils/app_text_style.dart';

class OnboardingContent extends StatelessWidget {
  final String imagePath;      // e.g. "assets/images/jar.png"
  final String title;          // e.g. "glass storage jar with golden lid"
  final String description;    // e.g. "Hermetic storage jar..."

  const OnboardingContent({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover, // or BoxFit.contain if you prefer
              ),
            ),


            Positioned(
              left: 16,
              right: 16,
              bottom: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.heading2
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style:AppTextStyle.body1
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
