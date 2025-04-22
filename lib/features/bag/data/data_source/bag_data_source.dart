import '../models/bag_item_model.dart';
import '../models/bag_model.dart';

class BagDataSource {
  BagModel _bag = BagModel(items: [], total: 0.0);

  BagModel getBag() => _bag;

  void addItem(BagItemModel item) {
    final List<BagItemModel> existingItems = [..._bag.items];
    final int index = existingItems.indexWhere((e) => e.productId == item.productId);

    if (index != -1) {
      existingItems[index].quantity += item.quantity;
    } else {
      existingItems.add(item);
    }

    final double updatedTotal = _calculateTotal(existingItems);
    _bag = _bag.copyWith(items: existingItems, total: updatedTotal);
  }

  void removeItem(String productId) {
    final List<BagItemModel> updatedItems =
    _bag.items.where((item) => item.productId != productId).toList();

    final double updatedTotal = _calculateTotal(updatedItems);
    _bag = _bag.copyWith(items: updatedItems, total: updatedTotal);
  }

  void updateQuantity(String productId, int quantity) {
    final List<BagItemModel> updatedItems = _bag.items.map((item) {
      if (item.productId == productId) {
        return BagItemModel(
          productId: item.productId,
          name: item.name,
          imageUrl: item.imageUrl,
          price: item.price,
          quantity: quantity,
        );
      }
      return item;
    }).toList();

    final double updatedTotal = _calculateTotal(updatedItems);
    _bag = _bag.copyWith(items: updatedItems, total: updatedTotal);
  }

  void applyPromo(String promoCode) {
    _bag = _bag.copyWith(promoCode: promoCode);
  }

  void clear() {
    _bag = BagModel(items: [], total: 0.0);
  }

  double _calculateTotal(List<BagItemModel> items) {
    double sum = 0.0;
    for (final item in items) {
      sum += item.price * item.quantity;
    }
    return sum;
  }
}
