// lib/core/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/core/app_router/routers.dart';
import 'package:ulmo/features/auth/presentation/controller/login_bloc/login_bloc.dart';
import 'package:ulmo/features/auth/presentation/views/login_screen.dart';
import 'package:ulmo/features/auth/presentation/views/otp_screen.dart';
import 'package:ulmo/features/categories/presentation/views/category_screen.dart';
import 'package:ulmo/features/favorite/presentation/controller/favorite_bloc.dart';
import 'package:ulmo/features/layout/presentation/controller/layout_bloc.dart';
import 'package:ulmo/features/layout/presentation/views/layout_screen.dart';
import 'package:ulmo/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:ulmo/features/product/domain/usecases/fetch_products.dart';
import 'package:ulmo/features/product/presentation/controller/product_bloc.dart';
import 'package:ulmo/features/product/presentation/controller/product_event.dart';
import 'package:ulmo/features/product/presentation/views/product_screen.dart';

import '../../features/auth/presentation/controller/otp_bloc/otp_bloc.dart';
import '../../features/auth/presentation/controller/register_bloc/register_bloc.dart';
import '../../features/auth/presentation/views/register_screen.dart';
import '../../features/categories/presentation/controller/category_bloc.dart';
import '../../features/categories/presentation/controller/category_event.dart';
import '../../features/categories/presentation/views/category_child_screen.dart';
import '../../features/splash/presntation/splash_screen.dart';
import '../di/di.dart';

class AppRouter {

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.onBoarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (_) => di<RegisterBloc>(), child: RegisterScreen()),
        );

      case Routes.login:
        return  MaterialPageRoute(
          builder: (_)=> BlocProvider(
              create: (_) => di<LoginBloc>(), child: LoginScreen()),
        );

      case Routes.verifyOtp:
        final args = settings.arguments as Map<String, dynamic>;
        final phoneNumber = args['phoneNumber'] as String;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di<OtpAuthBloc>(),
            child: OtpVerificationScreen(
              phoneNumber: phoneNumber,
            ),
          ),
        );



      case Routes.layout:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di<CategoryBloc>()..add(FetchCategories())),
            ],
            child: LayoutView(),
          ),
        );

      // case Routes.category:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      //       final parentDocId = args?['parentDocId'] as String?;
      //       final parentTitle = args?['parentTitle'] as String?;
      //
      //       if (parentDocId == null || parentTitle == null) {
      //         return const Scaffold(body: Center(child: Text("Missing category data")));
      //       }
      //
      //       return BlocProvider(
      //         create: (_) => di<CategoryBloc>()..add(FetchChildCategories(parentId: parentDocId)),
      //         child: ParentCategoryScreen(
      //           parentDocId: parentDocId,
      //           parentTitle: parentTitle,
      //         ),
      //       );
      //     },
      //   );

      // case Routes.product:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (_)=> ProductBloc(di<FetchProductsUseCase>())..add(LoadProductsEvent()),
      //         child: ProductScreen()
      //
      //   ));




      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}

