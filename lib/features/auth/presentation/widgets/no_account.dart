import 'package:flutter/material.dart';
import 'package:ulmo/core/utils/app_text_style.dart';

import '../../../../core/app_router/routers.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style:AppTextStyle.body2
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.register);
            },
            child: Text(
              'Register Now',
              style: AppTextStyle.body2
            ),
          ),
        ],
      ),
    );
  }
}
