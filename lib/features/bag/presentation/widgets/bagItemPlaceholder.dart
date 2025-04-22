import 'package:flutter/material.dart';

class BagItemPlaceholder extends StatelessWidget {
  const BagItemPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image placeholder
          Container(
            width: screenWidth * 0.2,
            height: screenWidth * 0.2,
            color: Colors.grey[300],
          ),
          const SizedBox(width: 12),

          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth * 0.4,
                  height: 16,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.only(bottom: 8),
                ),
                Container(
                  width: screenWidth * 0.3,
                  height: 16,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.only(bottom: 8),
                ),

                // Price & quantity row placeholders
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.2,
                      height: 16,
                      color: Colors.grey[300],
                    ),
                    const Spacer(),
                    Container(
                      width: 30,
                      height: 16,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
