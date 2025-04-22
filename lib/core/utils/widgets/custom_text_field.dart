
import 'package:flutter/material.dart';

import '../../themes/colors_style.dart';
import '../app_text_style.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? errorText;  // if not null, show error style
  final String? prefixPath;
  final String? suffixPath;
  final TextInputType? type;
  final TextEditingController? controller;
  final String? description;
  final bool? isPassword;
  final validtor;
  final suffixPressed;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.errorText,
    this.prefixPath,
    this.suffixPath,
    this.controller,
    this.isPassword =false,
    this.description,
    this.type,
    this.validtor,
    this.suffixPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Decide border color
    final borderColor = errorText == null
        ? AppColors.textFieldColor   // default gray-ish
        : AppColors.error;  // red for error

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor, width: 1),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
          obscureText: isPassword??false,

          controller: controller,
          keyboardType:type ,
          validator:validtor ,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyle.body2.copyWith(color: AppColors.black),
            prefixIcon: prefixPath == null
                ? null
                : Padding(
              padding: const EdgeInsets.all(8.0), // Adjust padding as needed
              child: Image.asset(prefixPath??"", width: 24, height: 24),
            ),
            suffixIcon: suffixPath == null
                ? null
                : InkWell(
                  onTap: suffixPressed,
                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(suffixPath??"", width: 24, height: 24),
                              ),
                ),
            filled: true,
            fillColor: AppColors.gray100, // slightly off-white
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: border,
            disabledBorder: border,
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: AppTextStyle.body2.copyWith(color: AppColors.error),
          ),
        ] else if (description != null && description!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            description!,
            style: AppTextStyle.body3.copyWith(color: AppColors.black),
          ),
        ],
      ],
    );
  }
}
