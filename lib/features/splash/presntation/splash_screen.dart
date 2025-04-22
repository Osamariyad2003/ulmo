
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ulmo/core/themes/colors_style.dart';
import 'package:ulmo/core/utils/app_text_style.dart';

import '../../../core/app_router/routers.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _checkUserStatus();
    });
  }

  void _checkUserStatus() async {
    final box = Hive.box('appBox');
    bool onboardingShown = box.get('onboardingShown', defaultValue: false);
    bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);

    print('Retrieved onboardingShown: $onboardingShown');
    print('Retrieved isLoggedIn: $isLoggedIn');

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, Routes.layout);
    } else if (onboardingShown) {
      print('Onboarding has been viewed. Navigating to login screen.');
      Navigator.pushReplacementNamed(context, Routes.login);
    } else {
      print('Navigating to onboarding screen.');
      Navigator.pushReplacementNamed(context, Routes.onBoarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.accentYellow, // brand background color
        child: Center(
          child: Text(
            'ulmo',
            style: AppTextStyle.heading1, // using your custom style
          ),
        ),
      ),
    );
  }
}
