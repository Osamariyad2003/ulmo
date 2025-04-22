import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class SocialCard extends StatelessWidget {
  const SocialCard({
    Key? key,
    required this.iconAssetPath,
    required this.onPressed,
  }) : super(key: key);


  final String iconAssetPath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 66,
        width: 66,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        // 1. Use Image.asset to load the icon from assets
        child: Image.asset(
          iconAssetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
