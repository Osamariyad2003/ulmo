import 'package:flutter/foundation.dart';
import '../models/bag_item_model.dart';
import '../models/bag_model.dart';

class BagDataSource {
  BagModel _bag = BagModel(items: [], total: 0.0);

  BagModel getBag() => _bag;

  void addItem(BagItemModel item) {
    debugPrint("Adding item to bag: ${item.name}, ID: ${item.productId}");

    final List<BagItemModel> existingItems = [..._bag.items];

    final String normalizedNewId = item.productId.trim().toLowerCase();

    final int index = existingItems.indexWhere(
      (e) => e.productId.trim().toLowerCase() == normalizedNewId,
    );

    if (index != -1) {
      debugPrint("Found existing item at index $index, updating quantity");
      existingItems[index] = existingItems[index].copyWith(
        quantity: existingItems[index].quantity + item.quantity,
      );
    } else {
      debugPrint("Adding new item to bag");
      existingItems.add(item);
    }

    final double updatedTotal = _calculateTotal(existingItems);
    _bag = _bag.copyWith(items: existingItems, total: updatedTotal);

    debugPrint(
      "Bag now has ${_bag.items.length} items with total \$${_bag.total}",
    );
  }

  void removeItem(String productId) {
    if (productId.isEmpty) {
      debugPrint("Cannot remove item with empty productId");
      return;
    }

    // Normalize ID for comparison
    final String normalizedId = productId.trim().toLowerCase();

    final List<BagItemModel> updatedItems =
        _bag.items.where((item) {
          return item.productId.trim().toLowerCase() != normalizedId;
        }).toList();

    final double updatedTotal = _calculateTotal(updatedItems);
    _bag = _bag.copyWith(items: updatedItems, total: updatedTotal);

    debugPrint("Removed item with ID: $productId");
  }

  void updateQuantity(String productId, int quantity) {
    if (productId.isEmpty || quantity < 1) {
      debugPrint("Invalid productId or quantity: $productId, $quantity");
      return;
    }

    // Normalize ID for comparison
    final String normalizedId = productId.trim().toLowerCase();

    final List<BagItemModel> updatedItems =
        _bag.items.map((item) {
          if (item.productId.trim().toLowerCase() == normalizedId) {
            return item.copyWith(quantity: quantity);
          }
          return item;
        }).toList();

    final double updatedTotal = _calculateTotal(updatedItems);
    _bag = _bag.copyWith(items: updatedItems, total: updatedTotal);

    debugPrint("Updated quantity for product $productId to $quantity");
  }

  void applyPromo(String promoCode) {
    _bag = _bag.copyWith(promoCode: promoCode);
    debugPrint("Applied promo code: ${promoCode.isEmpty ? 'None' : promoCode}");
  }

  void clear() {
    _bag = BagModel(items: [], total: 0.0);
    debugPrint("Cleared bag");
  }

  double _calculateTotal(List<BagItemModel> items) {
    double sum = 0.0;
    for (final item in items) {
      if (item.price > 0 && item.quantity > 0) {
        sum += item.price * item.quantity;
      }
    }
    return sum;
  }
}
