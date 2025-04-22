import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/bag_item_model.dart';
import '../../data/repo/bag_repo.dart';
import '../../data/repo/payment_repo.dart';
import 'bag_event.dart';
import 'bag_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bag_event.dart';
import 'bag_state.dart';

class BagBloc extends Bloc<BagEvent, BagState> {
  final BagRepositoryImpl bagRepository;
  final PaymentRepositoryImpl paymentRepository;

  String? selectedPaymentMethod;

  BagBloc({
    required this.bagRepository,
    required this.paymentRepository,
  }) : super(BagLoading()) {
    on<LoadBagEvent>(_onLoadBag);
    on<AddQuantityEvent>(_onAddQuantity);
    on<RemoveQuantityEvent>(_onRemoveQuantity);
    on<RemoveItemEvent>(_onRemoveItem);
    on<ApplyPromoEvent>(_onApplyPromo);
    on<ClearBagEvent>(_onClearBag);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
    on<AddItemEvent>((event, emit) async {
      final currentState = state;
      if (currentState is! BagLoaded) return;

      final newItem = BagItemModel(
        productId: event.item.productId,
        name: event.item.name,
        price: event.item.price,
        imageUrl: event.item.imageUrl,
        quantity: event.item.quantity,
      );

      bagRepository.addItem(newItem); // your local data management

      emit(BagLoaded(bag: bagRepository.getBag()));
    });


  }

  void _emitLoaded(Emitter<BagState> emit) {
    final bag = bagRepository.getBag();
    emit(BagLoaded(
      bag: bag,
      selectedPaymentMethod: selectedPaymentMethod,
    ));
  }

  void _onLoadBag(LoadBagEvent event, Emitter<BagState> emit) {
    _emitLoaded(emit);
  }

  void _onAddQuantity(AddQuantityEvent event, Emitter<BagState> emit) {
    final item = bagRepository.getBag().items.firstWhere((e) => e.productId == event.productId);
    bagRepository.updateQuantity(event.productId, item.quantity + 1);
    _emitLoaded(emit);
  }

  void _onRemoveQuantity(RemoveQuantityEvent event, Emitter<BagState> emit) {
    final item = bagRepository.getBag().items.firstWhere((e) => e.productId == event.productId);
    final newQty = item.quantity > 1 ? item.quantity - 1 : 1;
    bagRepository.updateQuantity(event.productId, newQty);
    _emitLoaded(emit);
  }

  void _onRemoveItem(RemoveItemEvent event, Emitter<BagState> emit) {
    bagRepository.removeItem(event.productId);
    _emitLoaded(emit);
  }

  void _onApplyPromo(ApplyPromoEvent event, Emitter<BagState> emit) {
    bagRepository.applyPromo(event.promoCode);
    _emitLoaded(emit);
  }

  void _onClearBag(ClearBagEvent event, Emitter<BagState> emit) {
    bagRepository.clear();
    _emitLoaded(emit);
  }

  void _onSelectPaymentMethod(SelectPaymentMethodEvent event, Emitter<BagState> emit) {
    selectedPaymentMethod = event.methodId;
    _emitLoaded(emit);
  }

  Future<void> _onConfirmPayment(ConfirmPaymentEvent event, Emitter<BagState> emit) async {
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
}
