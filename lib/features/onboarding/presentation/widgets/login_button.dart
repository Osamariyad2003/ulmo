import 'package:flutter/material.dart';

import '../../../../core/utils/app_text_style.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text('Login', style: AppTextStyle.body1),
    );
  }
}