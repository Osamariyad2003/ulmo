import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/core/utils/app_text_style.dart';
import 'package:ulmo/core/utils/widgets/custom_text_field.dart';
import 'package:ulmo/features/auth/presentation/controller/register_bloc/register_bloc.dart';
import 'package:ulmo/features/auth/presentation/controller/register_bloc/register_state.dart';

import '../../../../core/app_router/routers.dart';
import '../../../../core/di/di.dart';
import '../../../../core/themes/colors_style.dart';
import '../../../../core/utils/assets_data.dart';
import '../controller/register_bloc/register_event.dart';

class RegisterScreen extends StatelessWidget {
  final registerFormKey = GlobalKey<FormState>(); // Unique key for RegisterScreen
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final countryCotroller = TextEditingController();

  var isPasssword = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocProvider(
        create: (context) => RegisterBloc(di()),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Form(
                  key: registerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Image.asset(Assets.iconsUlmoIcon, height: screenHeight * 0.09),
                      SizedBox(height: screenHeight * 0.05),
                      CustomTextField(
                        controller: nameController,
                        type: TextInputType.text,
                        hintText: 'User Name',
                        validtor: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                        prefixPath: Assets.iconsPersonIcon,
                      ),
                      SizedBox(height: screenHeight * 0.02), // Spacing

                      CustomTextField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        hintText: 'Email Address',
                        validtor: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        prefixPath: Assets.iconsMailIcon, // SVG path for prefix
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Mobile Number Field
                      CustomTextField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        hintText: 'Phone Number',
                        validtor: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        prefixPath: Assets.iconsMailIcon, // SVG path for prefix
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextField(
                        controller: countryCotroller,
                        type: TextInputType.text,
                        hintText: 'Country',
                        validtor: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                        prefixPath: Assets.iconsPersonIcon,
                      ),
                      SizedBox(height: screenHeight * 0.02),



                      // Create Password Field
                      BlocBuilder<RegisterBloc,RegisterState>(
                        builder: (BuildContext context, RegisterState state) {
                          return CustomTextField(
                            controller: passwordController,
                            type: TextInputType.text,
                            isPassword: isPasssword,
                            suffixPath: Assets.iconsVisable_Eye_Icon,
                            suffixPressed: (){
                              isPasssword=!isPasssword;

                              BlocProvider.of<RegisterBloc>(context).add(
                                  TogglePasswordEvent(isPasssword)
                              );

                            },

                            hintText: 'Create Password',
                            validtor: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            prefixPath: Assets.iconsVisable_Eye_Icon, // SVG path for prefix
                          );
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Terms and Conditions Checkbox
                      BlocBuilder<RegisterBloc, RegisterState>(
                        builder: (context, state) {
                          bool isAccepted = false;
                          if (state is RegisterInitialState) {
                            isAccepted = state.termsAccepted;
                          }

                          return Row(
                            children: [
                              Checkbox(
                                value: isAccepted,
                                onChanged: (value) {
                                  BlocProvider.of<RegisterBloc>(context).add(
                                    ToggleTermsEvent(value ?? false),
                                  );
                                },
                                activeColor: Colors.white,
                              ),
                              Expanded(
                                child: Text(
                                  'By creating an account you agree to terms and conditions',
                                  style: AppTextStyle.body2
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Register Button
                      BlocBuilder<RegisterBloc, RegisterState>(
                        builder: (context, state) {
                          if (state is RegisterLoadingState) {
                            return const CircularProgressIndicator(); // Show loading spinner during registration
                          }
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (validateInputs()) {
                                  BlocProvider.of<RegisterBloc>(context).add(
                                    SignUpEvent(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      username: nameController.text,
                                      phone: phoneController.text,
                                      country:countryCotroller.text,
                                    ),
                                  );
                                }

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentYellow,
                                foregroundColor: AppColors.black,
                                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02), // Scaled padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Register',
                                style: TextStyle(fontSize: screenWidth * 0.045), // Scaled text size
                              ),
                            ),
                          );
                        },
                      ),


                      SizedBox(height: screenHeight * 0.02),

                      BlocListener<RegisterBloc, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterErrorState) {
                            print(state.message);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          } else if (state is RegisterSuccessState) {
                            Navigator.pushReplacementNamed(context, Routes.layout);
                          //     Navigator.pushReplacementNamed(
                            //          context,
                            //             Routes.verifyOtp,
                            //               arguments: {
                            //               'phoneNumber': phoneController.text,
                            //          },
                            //      );
                          }
                        },
                        child: const SizedBox.shrink(),

                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateInputs() {
    if (nameController.text.isEmpty) {
      return false;
    }
    if (emailController.text.isEmpty) {
      return false;
    }
    if (passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }
}
