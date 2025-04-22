import '../../data/models/bag_model.dart';

abstract class BagState {}

class BagLoading extends BagState {}

class BagLoaded extends BagState {
  final BagModel bag;
  final String? selectedPaymentMethod;

  BagLoaded({required this.bag, this.selectedPaymentMethod});
}

class PaymentProcessing extends BagState {}

class PaymentSuccess extends BagState {}

class BagError extends BagState {
  final String message;
  BagError(this.message);
}
