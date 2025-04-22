import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ulmo/core/utils/app_text_style.dart';

import '../../themes/colors_style.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.r)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const LoadingIndicator(
            indicatorType: Indicator.ballRotateChase,
            colors: [AppColors.accentYellow],
          ),
          SizedBox(height: 19),
          Text(
            'Please Wait',
            style: AppTextStyle.body0,
          ),
        ],
      ),
    );
  }
}
