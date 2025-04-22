import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onRemoveTile;

  const ProductTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.onRemoveTile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:  EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding:  EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  SizedBox(height: 4),
                  Text(title,
                      style:  TextStyle(
                        fontSize: 14,
                      )),
                   SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                   SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon:  Icon(Icons.remove),
                        onPressed: onRemove,
                        splashRadius: 20,
                      ),
                      Text(
                        quantity.toString(),
                        style:  TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon:  Icon(Icons.add),
                        onPressed: onAdd,
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon:  Icon(Icons.close),
              onPressed: onRemoveTile,
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
