import 'package:flutter/material.dart';

class ProductFavPlaceholder extends StatelessWidget {
  const ProductFavPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: screenWidth * 0.02,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for product image
          Container(
            width: screenWidth * 0.20,
            height: screenWidth * 0.20,
            color: Colors.grey[300],
          ),
          SizedBox(width: screenWidth * 0.04),

          // Placeholder for product text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "New" label placeholder
                Container(
                  width: screenWidth * 0.15,
                  height: 18,
                  color: Colors.grey[300],
                  margin: EdgeInsets.only(bottom: 8),
                ),
                // Title placeholder
                Container(
                  width: screenWidth * 0.4,
                  height: 20,
                  color: Colors.grey[300],
                  margin: EdgeInsets.only(bottom: 8),
                ),
                // Price placeholder
                Container(
                  width: screenWidth * 0.2,
                  height: 18,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),

          // Favorite icon placeholder
          Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.only(left: screenWidth * 0.02),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          )
        ],
      ),
    );
  }
}
