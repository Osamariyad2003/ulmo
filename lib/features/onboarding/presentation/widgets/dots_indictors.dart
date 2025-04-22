import 'package:flutter/material.dart';


class FullWidthLinesIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final double lineHeight;
  final Color activeColor;
  final Color inactiveColor;
  final double spacing;

  const FullWidthLinesIndicator({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    this.lineHeight = 2.0,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.white54,
    this.spacing = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalPages, (index) {
        final bool isActive = (index == currentPage);

        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            height: lineHeight,
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        );
      }),
    );
  }
}
