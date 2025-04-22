import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:ulmo/core/utils/widgets/custom_text_field.dart';

import '../../../../core/app_router/routers.dart';
import '../../../../core/themes/colors_style.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/utils/assets_data.dart';
import '../../../../core/utils/widgets/custom_button.dart';
import '../controller/login_bloc/login_bloc.dart';
import '../controller/login_bloc/login_event.dart';
import '../controller/login_bloc/login_state.dart';
import '../widgets/no_account.dart';
import '../widgets/social_card.dart';
// import your other widgets...

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  // 1) References to Hive box, form key, and controllers.
  // In a stateless widget, these will re-initialize if the widget is rebuilt from scratch.
  final box = Hive.box('appBox');
  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<LoginBloc, LoginStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          box.put('isLoggedIn', true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Login Successful',
                style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width * 0.04,
                ),
              ),
            ),
          );

          Navigator.pushReplacementNamed(context, Routes.layout);

        } else if (state is LoginErrorState) {
          print(state.error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                state.error,
                style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width * 0.04,
                ),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final bloc = BlocProvider.of<LoginBloc>(context);

        return Scaffold(
          backgroundColor: AppColors.backgroundLight, // or any desired background color
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.07,
              ),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.06),
                      Image.asset(Assets.iconsUlmoIcon, height: screenHeight * 0.09),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      // Logo
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Login',
                              textAlign: TextAlign.start,
                              style: AppTextStyle.heading2
                            ),
                             SizedBox(height: 8), // Spacing between title and subtitle
                             Text(
                              'Please enter your credentials to continue',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.gray500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.06,
                      ),

                      // The login form
                      Form(
                        key: loginFormKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              prefixPath: Assets.iconsMailIcon,
                              hintText: 'User Name',
                              controller: emailController,
                              validtor: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'Please Enter Email Address';
                                }
                                bool emailValid = RegExp(
                                  r"^[\w.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
                                ).hasMatch(text);
                                if (!emailValid) {
                                  return 'Please Enter Valid Email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: screenHeight * 0.04,),
                            CustomTextField(
                              prefixPath: Assets.iconsVisable_Eye_Icon,
                              hintText: 'Password',
                              suffixPressed:(){
                                isPassword=!isPassword;

                                bloc.add(TogglePasswordEvent(isPassword));

                              },
                              suffixPath:  isPassword
                                    ?  Assets.iconsVisable_Eye_Icon
                                    : Assets.iconsVisable_Eye_Icon,

                              isPassword: bloc.isObsecure,
                              controller: passwordController,
                              validtor: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'Please Enter Password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),

                            // Login button
                            CustomButton(
                              label: 'Login',
                              onPressed: () {
                                if (loginFormKey.currentState!.validate()) {
                                  bloc.add(
                                    signInWithEmailAndPasswordEvent(
                                      emailController.text,
                                      passwordController.text,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),


                      SocialCard(
                        iconAssetPath:Assets.iconsGoogleIcon ,
                        onPressed: () {
                          bloc.add(signInGoogleEvent());
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      const NoAccountText(),
                    ],
                  ),
                ),
              ),
            ),
        );

      },
    );
  }
}
