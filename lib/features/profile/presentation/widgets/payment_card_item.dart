import 'package:flutter/material.dart';
import 'package:ulmo/core/themes/colors_style.dart';
import '../../data/models/credit_card.dart';

class PaymentCardItem extends StatelessWidget {
  final CreditCard card;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const PaymentCardItem({
    Key? key,
    required this.card,
    required this.onSetDefault,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Card icon (Visa, Mastercard, etc.)
          _buildCardIcon(),
          const SizedBox(width: 16),

          // Card details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getCardTypeText() ?? "Credit Card",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '•••• •••• •••• ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                if (card.expiryDate != null)
                  Text(
                    'Expires ${card.expiryDate}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
              ],
            ),
          ),

          // Actions
          if (card.isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Default',
                style: TextStyle(
                  color: AppColors.accentYellow,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            TextButton(
              onPressed: onSetDefault,
              child: const Text('Set as default'),
            ),

          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildCardIcon() {
    String assetName;

    switch (card.cardType?.toLowerCase()) {
      case 'visa':
        assetName = 'assets/icons/visa.png';
        break;
      case 'mastercard':
        assetName = 'assets/icons/mastercard.png';
        break;
      case 'amex':
      case 'american express':
        assetName = 'assets/icons/amex.png';
        break;
      case 'discover':
        assetName = 'assets/icons/discover.png';
        break;
      default:
        assetName = 'assets/icons/credit_card.png';
    }

    return Image.asset(
      assetName,
      width: 40,
      height: 25,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 40,
          height: 25,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(Icons.credit_card, color: Colors.white, size: 20),
        );
      },
    );
  }

  String? _getCardTypeText() {
    if (card.cardType?.isEmpty ?? true) {
      return 'Credit Card';
    } else {
      // Capitalize the first letter of each word
      return card.cardType
          ?.split(' ')
          .map((word) {
            if (word.isEmpty) return '';
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          })
          .join(' ');
    }
  }
}
