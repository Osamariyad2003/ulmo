import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: screenWidth * 0.25,
              height: screenWidth * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 16),

            // Placeholder line for Name/Username
            Container(
              width: screenWidth * 0.4,
              height: 18,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),

            // Placeholder line for secondary info (e.g., handle or subtitle)
            Container(
              width: screenWidth * 0.3,
              height: 16,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),

            // Row placeholders for stats (e.g., Followers / Following / Posts)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statPlaceholder(screenWidth),
                _statPlaceholder(screenWidth),
                _statPlaceholder(screenWidth),
              ],
            ),
            const SizedBox(height: 24),

            // Placeholder block for bio or user description
            Container(
              width: screenWidth * 0.8,
              height: 60,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),

            // Example of additional placeholder lines
            Container(
              width: screenWidth * 0.7,
              height: 16,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Container(
              width: screenWidth * 0.6,
              height: 16,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statPlaceholder(double screenWidth) {
    return Column(
      children: [
        Container(
          width: screenWidth * 0.1,
          height: 16,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 6),
        Container(
          width: screenWidth * 0.1,
          height: 16,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
