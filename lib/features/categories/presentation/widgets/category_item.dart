import 'package:flutter/material.dart';

import '../../../../core/models/catagory.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;
  const CategoryItem({Key? key, required this.onTap,required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          // Circular image
          ClipOval(
            child: Image.network(
              category.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Category name
          Text(
            category.name,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
