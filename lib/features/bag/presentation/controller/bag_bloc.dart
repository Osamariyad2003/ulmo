import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/bag_item_model.dart';
import '../../data/repo/bag_repo.dart';
import '../../data/repo/payment_repo.dart';
import 'bag_event.dart';
import 'bag_state.dart';

class BagBloc extends Bloc<BagEvent, BagState> {
  final BagRepositoryImpl bagRepository;
  final PaymentRepositoryImpl paymentRepository;

  String? selectedPaymentMethod;

  BagBloc({required this.bagRepository, required this.paymentRepository})
    : super(BagLoading()) {
    on<LoadBagEvent>(_onLoadBag);
    on<AddQuantityEvent>(_onAddQuantity);
    on<RemoveQuantityEvent>(_onRemoveQuantity);
    on<RemoveItemEvent>(_onRemoveItem);
    on<ApplyPromoEvent>(_onApplyPromo);
    on<ClearBagEvent>(_onClearBag);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
    on<AddItemEvent>(_onAddItem);
  }

  void _emitLoaded(Emitter<BagState> emit) {
    try {
      final bag = bagRepository.getBag();
      print(
        "Emitting BagLoaded with ${bag.items.length} items, total: ${bag.total}",
      );
      for (var item in bag.items) {
        print(
          "Item in bag: ${item.name}, quantity: ${item.quantity}, id: ${item.productId}",
        );
      }
      emit(BagLoaded(bag: bag, selectedPaymentMethod: selectedPaymentMethod));
    } catch (e) {
      print("Error emitting bag state: ${e.toString()}");
      emit(BagError("Failed to load bag: ${e.toString()}"));
    }
  }

  void _onLoadBag(LoadBagEvent event, Emitter<BagState> emit) {
    _emitLoaded(emit);
  }

  void _onAddQuantity(AddQuantityEvent event, Emitter<BagState> emit) {
    try {
      final bag = bagRepository.getBag();
      final itemIndex = bag.items.indexWhere(
        (e) =>
            e.productId.trim().toLowerCase() ==
            event.productId.trim().toLowerCase(),
      );

      if (itemIndex != -1) {
        final item = bag.items[itemIndex];
        bagRepository.updateQuantity(event.productId, item.quantity + 1);
        _emitLoaded(emit);
      } else {
        emit(BagError("Item not found in bag"));
      }
    } catch (e) {
      print("Error adding quantity: ${e.toString()}");
      emit(BagError("Failed to add quantity: ${e.toString()}"));
    }
  }

  void _onRemoveQuantity(RemoveQuantityEvent event, Emitter<BagState> emit) {
    try {
      final bag = bagRepository.getBag();
      final itemIndex = bag.items.indexWhere(
        (e) =>
            e.productId.trim().toLowerCase() ==
            event.productId.trim().toLowerCase(),
      );

      if (itemIndex != -1) {
        final item = bag.items[itemIndex];
        final newQty = item.quantity > 1 ? item.quantity - 1 : 1;
        bagRepository.updateQuantity(event.productId, newQty);
        _emitLoaded(emit);
      } else {
        emit(BagError("Item not found in bag"));
      }
    } catch (e) {
      print("Error removing quantity: ${e.toString()}");
      emit(BagError("Failed to remove quantity: ${e.toString()}"));
    }
  }

  void _onRemoveItem(RemoveItemEvent event, Emitter<BagState> emit) {
    try {
      bagRepository.removeItem(event.productId);
      _emitLoaded(emit);
    } catch (e) {
      emit(BagError("Failed to remove item: ${e.toString()}"));
    }
  }

  void _onApplyPromo(ApplyPromoEvent event, Emitter<BagState> emit) {
    try {
      bagRepository.applyPromo(event.promoCode);
      _emitLoaded(emit);
    } catch (e) {
      emit(BagError("Failed to apply promo: ${e.toString()}"));
    }
  }

  void _onClearBag(ClearBagEvent event, Emitter<BagState> emit) {
    try {
      bagRepository.clear();
      _emitLoaded(emit);
    } catch (e) {
      emit(BagError("Failed to clear bag: ${e.toString()}"));
    }
  }

  void _onSelectPaymentMethod(
    SelectPaymentMethodEvent event,
    Emitter<BagState> emit,
  ) {
    try {
      selectedPaymentMethod = event.methodId;
      _emitLoaded(emit);
    } catch (e) {
      emit(BagError("Failed to select payment method: ${e.toString()}"));
    }
  }

  Future<void> _onConfirmPayment(
    ConfirmPaymentEvent event,
    Emitter<BagState> emit,
  ) async {
    if (selectedPaymentMethod == null) {
      emit(BagError("Please select a payment method."));
      return;
    }

    emit(PaymentProcessing());
    try {
      await paymentRepository.pay();
      emit(PaymentSuccess());
      bagRepository.clear();
      selectedPaymentMethod = null;
      _emitLoaded(emit);
    } catch (e) {
      emit(BagError("Payment failed: ${e.toString()}"));
    }
  }

  void _onAddItem(AddItemEvent event, Emitter<BagState> emit) {
    try {
      print(
        "Adding item to bag: ${event.item.name}, ID: ${event.item.productId}",
      );

      final newItem = BagItemModel(
        productId: event.item.productId.trim(), // Normalize ID when adding
        name: event.item.name,
        price: event.item.price,
        imageUrl: event.item.imageUrl,
        quantity: event.item.quantity,
      );

      bagRepository.addItem(newItem);
      _emitLoaded(emit);
    } catch (e) {
      print("Error adding item to bag: ${e.toString()}");
      emit(BagError("Failed to add item: ${e.toString()}"));
    }
  }
}
