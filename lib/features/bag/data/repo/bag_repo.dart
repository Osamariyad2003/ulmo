import 'package:ulmo/core/models/product.dart';

import '../data_source/bag_data_source.dart';
import '../models/bag_item_model.dart';
import '../models/bag_model.dart';

class BagRepositoryImpl  {
  final BagDataSource bagDataSource;

  BagRepositoryImpl({required this.bagDataSource});

  BagModel getBag() => bagDataSource.getBag();

  void addItem(BagItemModel item) => bagDataSource.addItem(item);

  void removeItem(String productId) => bagDataSource.removeItem(productId);

  void updateQuantity(String productId, int quantity) =>
      bagDataSource.updateQuantity(productId, quantity);

  void applyPromo(String promoCode) => bagDataSource.applyPromo(promoCode);

  void clear() => bagDataSource.clear();
}
