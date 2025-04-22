import 'package:flutter/material.dart';
import '../../themes/colors_style.dart';
import '../app_text_style.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool showLockIcon; // if you want a lock icon for some reason

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
    this.showLockIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Decide background color based on enabled/disabled
    final backgroundColor = disabled
        ? AppColors.backgroundLight    // e.g., your gray color
        : AppColors.accentYellow;  // e.g., your yellow brand color

    final contentColor = disabled ? AppColors.textFieldColor : AppColors.black;

    return SizedBox(
      height: 48, // or any design spec
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyle.body1.copyWith(color: contentColor),
            ),
            if (showLockIcon) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.lock,
                size: 18,
                color: contentColor,
              ),
            ]
          ],
        ),
      ),
    );
  }
}