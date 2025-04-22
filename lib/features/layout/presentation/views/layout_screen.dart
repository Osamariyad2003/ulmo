import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/core/utils/assets_data.dart';
import 'package:ulmo/features/bag/presentation/views/bag_screen.dart';

import '../../../categories/presentation/views/category_screen.dart';
import '../../../favorite/presentation/views/fav_screen.dart';
import '../../../profile/presentation/views/profile_screen.dart';
import '../controller/layout_bloc.dart';
import '../controller/layout_event.dart';
import '../controller/layout_state.dart';

class LayoutView extends StatelessWidget {
  LayoutView({super.key});


  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<LayoutBloc, LayoutState>(
          buildWhen: (previous, current) =>
          previous.bottomNavIndex != current.bottomNavIndex,
          builder: (context, state) => Scaffold(
            body: [
              CategoryScreen(),
              BagScreen(),
              ProductFavScreen(),
              ProfileScreen(),
            ][state.bottomNavIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.bottomNavIndex,
              onTap: (index) {
                context.read<LayoutBloc>().add(ChangeBottomNavIndex(index));
              },
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  icon: state.bottomNavIndex == 0
                      ? Image.asset(Assets.iconsUlmoIcon, width: 30, height: 30)
                      : ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                    child: Image.asset(Assets.iconsUlmoIcon, width: 30, height: 30),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: state.bottomNavIndex == 1
                      ? Image.asset(Assets.iconsBagIcon, width: 30, height: 30)
                      : ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                    child: Image.asset(Assets.iconsBagIcon, width: 30, height: 30),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: state.bottomNavIndex == 2
                      ? Image.asset(Assets.iconsFavIcon, width: 30, height: 30)
                      : ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                    child: Image.asset(Assets.iconsFavIcon, width: 30, height: 30),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: state.bottomNavIndex == 3
                      ? Image.asset(Assets.iconsPersonIcon, width: 30, height: 30)
                      : ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                    child: Image.asset(Assets.iconsPersonIcon, width: 30, height: 30),
                  ),
                  label: '',
                ),
              ],
            )

          ));
  }
}
