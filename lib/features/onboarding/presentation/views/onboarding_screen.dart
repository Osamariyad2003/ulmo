import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ulmo/features/onboarding/presentation/widgets/login_button.dart';
import '../../../../core/app_router/routers.dart';
import '../widgets/dots_indictors.dart';
import '../widgets/onboarding_data.dart';
import '../widgets/skip_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void finishOnboarding() async {
    final box = Hive.box('appBox');

    print('Saving onboarding status...');
    await box.put('onboardingShown', true);
    print('Onboarding status saved.');

    bool onboardingCheck = box.get('onboardingShown');
    print('Onboarding status after saving: $onboardingCheck');

    if (onboardingCheck) {
      Navigator.pushReplacementNamed(context, Routes.login);
    } else {
      print('Failed to save onboarding state.');
    }
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _skipToLastPage() async{
    _pageController.jumpToPage(onboardingScreens.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingScreens.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return onboardingScreens[index];
              },
            ),
          ),
          if(onboardingScreens.length - 1 ==_currentPage)
            Positioned(
              top: 30,
              right: 20,
              child: LoginButton(onPressed:finishOnboarding)),
          Positioned(
            top: 30,
            left: 20,
              child: SkipButton(onPressed:_skipToLastPage)),


          Padding(
            padding: EdgeInsets.only(
             bottom: MediaQuery.of(context).size.height * 0.02,
            right: MediaQuery.of(context).size.width * 0.08,
            left: MediaQuery.of(context).size.width * 0.08,
          ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8),
                  SizedBox(
                    child: FullWidthLinesIndicator(
                      currentPage: _currentPage,
                      totalPages: onboardingScreens.length,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white54,
                      lineHeight: 2,
                      spacing: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),



        ],
      ),
    );
  }
}