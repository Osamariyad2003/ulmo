import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onBack;

  const CustomScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: onBack != null
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        )
            : null,
        title: Text(title),
      ),
      body: SafeArea(child: body),
    );
  }
}
