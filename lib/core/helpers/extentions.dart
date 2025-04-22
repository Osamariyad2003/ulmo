import 'package:flutter/material.dart';

import '../utils/widgets/loadin_dialog.dart';

extension ShowLoadingDialog on BuildContext {
  Future<void> showLoadingDialog() async => await showDialog<void>(
    context: this,
    barrierDismissible: false,
    builder: (_) => const LoadingDialog(),
  );
}

extension AppNavigator on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(
      String newRoute, {
        Object? arguments,
      }) {
    return Navigator.pushReplacementNamed(this, newRoute, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
      String newRoute, {
        Object? arguments,
      }) {
    return Navigator.pushNamedAndRemoveUntil(
      this,
      newRoute,
          (Route<dynamic> route) => false, // remove all previous routes
      arguments: arguments,
    );
  }

  void pop() => Navigator.pop(this);
}

extension MediaQueryExtension on BuildContext {
  double get screenHeight => MediaQuery.sizeOf(this).height;
  double get screenWidth => MediaQuery.sizeOf(this).width;
}


extension SnackBarExtension on BuildContext {

  void showCustomSnackBar({
    required String message,
    bool showSpinner = false,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final snackBar = SnackBar(
      backgroundColor: Colors.black, // or any color
      content: Row(
        children: [
          if (showSpinner)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white, // match your design
              ),
            ),
          if (showSpinner) const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(
        label: actionLabel,
        textColor: Colors.yellow,
        onPressed: onAction,
      )
          : null,
    );

    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}
