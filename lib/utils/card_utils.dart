import 'package:flutter/material.dart';

/// A utility class for card-related functionality
class CardUtils {
  /// Creates a standard card with consistent styling
  static Widget createStandardCard({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
    Color? backgroundColor,
    double elevation = 2.0,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    bool useShadow = true,
  }) {
    return Container(
      decoration:
          useShadow
              ? BoxDecoration(
                color: backgroundColor ?? Colors.white,
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              )
              : BoxDecoration(
                color: backgroundColor ?? Colors.white,
                borderRadius: borderRadius,
              ),
      child: Padding(padding: padding, child: child),
    );
  }

  /// Creates a clickable card with hover effect
  static Widget createClickableCard({
    required Widget child,
    required VoidCallback onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
    Color? backgroundColor,
    Color? hoverColor,
    double elevation = 2.0,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      hoverColor: hoverColor ?? Colors.grey.withOpacity(0.1),
      child: createStandardCard(
        child: child,
        padding: padding,
        backgroundColor: backgroundColor,
        elevation: elevation,
        borderRadius: borderRadius,
      ),
    );
  }

  /// Creates a card with an image header
  static Widget createImageCard({
    required String imageUrl,
    required Widget content,
    double? height,
    double? width,
    BoxFit imageFit = BoxFit.cover,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.all(16.0),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    bool useShadow = true,
  }) {
    return Container(
      height: height,
      width: width,
      decoration:
          useShadow
              ? BoxDecoration(
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              )
              : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: borderRadius.topLeft,
              topRight: borderRadius.topRight,
            ),
            child: Image.network(imageUrl, fit: imageFit),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: borderRadius.bottomLeft,
                bottomRight: borderRadius.bottomRight,
              ),
            ),
            padding: contentPadding,
            child: content,
          ),
        ],
      ),
    );
  }

  /// Creates a grid of cards
  static Widget createCardGrid({
    required List<Widget> cards,
    int crossAxisCount = 2,
    double spacing = 16.0,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
  }) {
    return Padding(
      padding: padding,
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: cards,
      ),
    );
  }
}
