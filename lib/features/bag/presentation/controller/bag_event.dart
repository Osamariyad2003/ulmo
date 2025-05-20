import '../../../../core/models/product.dart';
import '../../data/models/bag_item_model.dart';

abstract class BagEvent {}

class AddItemEvent extends BagEvent {
  final BagItemModel item;
  AddItemEvent(this.item);
}

class LoadBagEvent extends BagEvent {}

class AddQuantityEvent extends BagEvent {
  final String productId;
  AddQuantityEvent(this.productId);
}

class RemoveQuantityEvent extends BagEvent {
  final String productId;
  RemoveQuantityEvent(this.productId);
}

class RemoveItemEvent extends BagEvent {
  final String productId;
  RemoveItemEvent(this.productId);
}

class ApplyPromoEvent extends BagEvent {
  final String promoCode;
  ApplyPromoEvent(this.promoCode);
}

class ClearBagEvent extends BagEvent {}

class SelectPaymentMethodEvent extends BagEvent {
  final String methodId;
  SelectPaymentMethodEvent(this.methodId);
}

class ConfirmPaymentEvent extends BagEvent {}

class UpdateQuantityEvent extends BagEvent {
  final String productId;
  final int quantity;

  UpdateQuantityEvent({required this.productId, required this.quantity});
}
