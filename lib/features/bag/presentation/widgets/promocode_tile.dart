import 'package:flutter/material.dart';

class PromoCodeTile extends StatelessWidget {
  final String promoCode;
  final VoidCallback onRemove;

  const PromoCodeTile({
    super.key,
    required this.promoCode,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'promocode',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
         SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  promoCode,
                  style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child:  Icon(Icons.close, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
