import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/themes/colors_style.dart';
import '../controller/otp_bloc/otp_bloc.dart';
import '../controller/otp_bloc/otp_event.dart';
import '../controller/otp_bloc/otp_state.dart';

class ContinueButton extends StatelessWidget {
  final bool isButtonEnabled;
  final String otpCode;
  final Future<void> Function() showLoadingDialog;

  const ContinueButton({
    Key? key,
    required this.isButtonEnabled,
    required this.otpCode,
    required this.showLoadingDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpAuthBloc, OtpAuthState>(
      builder: (context, state) {
        if (state is OtpAuthLoading) {
          showLoadingDialog();
        } else if (state is OtpAuthSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is OtpAuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
        return GestureDetector(
          onTap: isButtonEnabled
              ? () {
            context.read<OtpAuthBloc>().add(
              VerifyOtpEvent(
                verificationId: '',
                otpCode: otpCode,
              ),
            );
            showLoadingDialog();
          }
              : null,
          child: Container(
            width: 324.w,
            height: 57.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(45.r),
            ),
            child: Center(
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentYellow,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}