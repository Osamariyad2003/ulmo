import 'package:flutter/material.dart';
import '../../../../core/utils/assets_data.dart';
import 'onboarding_content.dart';

final List<Widget> onboardingScreens = [
  const OnboardingContent(
    title: "like in a Restaurant but at home",
    description:
    ", consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea qui officia deserunt mollit anim id est laborum.",
    imagePath: Assets.imagesOnborading_first,
  ),
  const OnboardingContent(
    title: "like in a Restaurant but at home",
    description:
    ", consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea qui officia deserunt mollit anim id est laborum.",
    imagePath: Assets.imagesOnborading_second,
  ),
  const OnboardingContent(
    title: "like in a Restaurant but at home",
    description:
    ", consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea qui officia deserunt mollit anim id est laborum.",
    imagePath: Assets.imagesOnborading_third,
  ),
];