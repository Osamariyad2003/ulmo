import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/features/bag/domain/usecases/pay_usecase.dart';
import 'package:ulmo/features/bag/domain/usecases/update_item_usecase.dart';
import 'package:ulmo/features/bag/presentation/controller/bag_event.dart';
import 'package:ulmo/features/bag/presentation/controller/bag_state.dart';
import 'package:ulmo/features/delivery/data/model/delivery_model.dart';
import 'package:ulmo/features/delivery/presentation/controller/delivery_state.dart';
import '../../domain/usecases/add_item_usecase.dart';
import '../../domain/usecases/remove_item_usecase.dart';
import '../../domain/usecases/get_bag_usecase.dart';
import '../../domain/usecases/clear_bag_usecase.dart';
import '../../data/models/bag_item_model.dart';
import 'package:ulmo/features/delivery/presentation/controller/delivery_bloc.dart';

class BagBloc extends Bloc<BagEvent, BagState> {
  final AddItemToBagUseCase addItemUseCase;
  final RemoveItemFromBagUseCase removeItemUseCase;
  final GetBagUseCase getBagUseCase;
  final ClearBagUseCase clearBagUseCase;
  final UpdateBagItemQuantityUseCase updateBagItemQuantityUseCase;
  final PayUseCase processPaymentUseCase;
  final DeliveryBloc deliveryBloc;

  String? selectedPaymentMethod;

  BagBloc({
    required this.addItemUseCase,
    required this.removeItemUseCase,
    required this.updateBagItemQuantityUseCase,
    required this.getBagUseCase,
    required this.clearBagUseCase,
    required this.processPaymentUseCase,
    required this.deliveryBloc,
  }) : super(BagLoading()) {
    on<LoadBagEvent>(_onLoadBag);
    on<AddQuantityEvent>(_onAddQuantity);
    on<RemoveQuantityEvent>(_onRemoveQuantity);
    on<RemoveItemEvent>(_onRemoveItem);
    // on<ApplyPromoEvent>(_onApplyPromo);
    on<ClearBagEvent>(_onClearBag);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
    on<AddItemEvent>(_onAddItem);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
  }

  Future<void> _emitLoaded(Emitter<BagState> emit) async {
    try {
      final bag = await getBagUseCase.call();
      emit(BagLoaded(bag: bag, selectedPaymentMethod: selectedPaymentMethod));
    } catch (e) {
      emit(BagError("Failed to load bag: ${e.toString()}"));
    }
  }

  void _onLoadBag(LoadBagEvent event, Emitter<BagState> emit) {
    _emitLoaded(emit);
  }

  Future<void> _onAddQuantity(
    AddQuantityEvent event,
    Emitter<BagState> emit,
  ) async {
    try {
      final bag = await getBagUseCase.call();
      final itemIndex = bag.items.indexWhere(
        (e) =>
            e.productId.trim().toLowerCase() ==
            event.productId.trim().toLowerCase(),
      );

      if (itemIndex != -1) {
        final item = bag.items[itemIndex];
        updateBagItemQuantityUseCase.call(item.productId, item.quantity + 1);
        await _emitLoaded(emit);
      } else {
        emit(BagError("Item not found in bag"));
      }
    } catch (e) {
      emit(BagError("Failed to add quantity: ${e.toString()}"));
    }
  }

  Future<void> _onRemoveQuantity(
    RemoveQuantityEvent event,
    Emitter<BagState> emit,
  ) async {
    try {
      final bag = await getBagUseCase.call();
      final itemIndex = bag.items.indexWhere(
        (e) =>
            e.productId.trim().toLowerCase() ==
            event.productId.trim().toLowerCase(),
      );

      if (itemIndex != -1) {
        final item = bag.items[itemIndex];
        final newQty = item.quantity > 1 ? item.quantity - 1 : 1;
        updateBagItemQuantityUseCase.call(event.productId, newQty);
        await _emitLoaded(emit);
      } else {
        emit(BagError("Item not found in bag"));
      }
    } catch (e) {
      emit(BagError("Failed to remove quantity: ${e.toString()}"));
    }
  }

  Future<void> _onAddItem(AddItemEvent event, Emitter<BagState> emit) async {
    try {
      final newItem = BagItemModel(
        productId: event.item.productId.trim(),
        name: event.item.name,
        price: event.item.price,
        imageUrl: event.item.imageUrl,
      );
      addItemUseCase.call(newItem);
      await _emitLoaded(emit);
    } catch (e) {
      emit(BagError("Failed to add item: ${e.toString()}"));
    }
  }

  Future<void> _onRemoveItem(
    RemoveItemEvent event,
    Emitter<BagState> emit,
  ) async {
    try {
      removeItemUseCase.call(event.productId);
      await _emitLoaded(emit);
    } catch (e) {
      emit(BagError("Failed to remove item: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<BagState> emit,
  ) async {
    try {
      updateBagItemQuantityUseCase.call(event.productId, event.quantity);
      await _emitLoaded(emit);
    } catch (e) {
      emit(BagError("Failed to update quantity: ${e.toString()}"));
    }
  }

  // Future<void> _onApplyPromo(ApplyPromoEvent event, Emitter<BagState> emit) async {
  //   try {
  //     await applyPromoUseCase.execute(event.promoCode);
  //     await _emitLoaded(emit);
  //   } catch (e) {
  //     emit(BagError("Failed to apply promo: ${e.toString()}"));
  //   }
  // }

  Future<void> _onClearBag(ClearBagEvent event, Emitter<BagState> emit) async {
    try {
      clearBagUseCase.call();
      await _emitLoaded(emit);
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

    final deliveryState = deliveryBloc.state;
    if (deliveryState is! DeliverySelected) {
      emit(BagError("Please complete delivery information."));
      return;
    }

    // Validate delivery info is complete
    if (!_isDeliveryInfoComplete(deliveryState)) {
      emit(BagError("Please complete all delivery information."));
      return;
    }

    emit(PaymentProcessing());
    try {
      // Create delivery info from state
      final deliveryInfo = DeliveryInfo(
        address: deliveryState.address,
        lat: deliveryState.lat,
        lng: deliveryState.lng,
        method: deliveryState.method,
        date: deliveryState.date!,
        time: deliveryState.time!,
        userId: '',
      );

      // Process payment
      await processPaymentUseCase.call(deliveryInfo);

      // Clear bag and reset payment method
      clearBagUseCase.call();
      selectedPaymentMethod = null;

      emit(PaymentSuccess());
    } catch (e) {
      emit(BagError("Payment failed: ${e.toString()}"));
    }
  }

  bool _isDeliveryInfoComplete(DeliverySelected state) {
    return state.address.isNotEmpty &&
        state.method.isNotEmpty &&
        state.date != null &&
        state.time != null;
  }
}
