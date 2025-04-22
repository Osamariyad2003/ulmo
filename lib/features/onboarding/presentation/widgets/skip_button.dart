import 'package:flutter/material.dart';
import 'package:ulmo/core/utils/app_text_style.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SkipButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text('skip', style: AppTextStyle.body1),
    );
  }
}
