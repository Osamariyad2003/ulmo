import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulmo/core/helpers/extentions.dart';
import 'package:ulmo/features/auth/presentation/widgets/continue_button.dart';

import '../../../../core/app_router/routers.dart';
import '../../../../core/themes/colors_style.dart';
import '../controller/otp_bloc/otp_bloc.dart';
import '../controller/otp_bloc/otp_event.dart';
import '../controller/otp_bloc/otp_state.dart';


class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

   OtpVerificationScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String otpCode = "";
  bool isButtonEnabled = false;

  void _onOtpChange(String code) {
    setState(() {
      otpCode = code;
      isButtonEnabled = code.length == 6;
    });
  }

  Widget _buildOtpField() {
    return OtpTextField(
      onSubmit: (value) => _onOtpChange(value),
      onCodeChanged: (_) => setState(() => isButtonEnabled = false),
      focusedBorderColor: Colors.white,
      showFieldAsBox: true,
      fillColor: Colors.white,
      fieldWidth: 60.w,
      textStyle: TextStyle(
        fontSize: 24.sp,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      filled: true,
    );
  }




  @override
  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpAuthBloc, OtpAuthState>(
      listener: (context, state) {
        if (state is OtpAuthLoading) {
          context.showLoadingDialog();
        } else if (state is OtpAuthSuccess) {
          Navigator.of(context).pop(); // close dialog
          Navigator.pushReplacementNamed(context, Routes.layout); // or any screen
        } else if (state is OtpAuthFailure) {
          Navigator.of(context).pop(); // close dialog
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Error"),
              content: Text(state.errorMessage),
            ),
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOtpField(),
              SizedBox(height: 20.h),
              ContinueButton(
                isButtonEnabled: isButtonEnabled,
                otpCode: otpCode,
                showLoadingDialog: context.showLoadingDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
