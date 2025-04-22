import 'package:flutter/material.dart';
import '../../themes/colors_style.dart';
import '../app_text_style.dart';

class CustomCell extends StatelessWidget {
  final Widget leading;    // e.g., Icon, CircleAvatar
  final String title;
  final Widget? trailing;  // e.g., Icon(Icons.chevron_right), a Button, etc.
  final VoidCallback? onTap;

  const CustomCell({
    Key? key,
    required this.leading,
    required this.title,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.body1.copyWith(color: AppColors.black),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}