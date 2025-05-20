import '../../../../core/models/user.dart' as app_models;
import '../../data/models/credit_card.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final app_models.User user;

  ProfileLoaded(this.user);
}

class ProfileUpdated extends ProfileState {
  final app_models.User user;

  ProfileUpdated(this.user);
}

class ProfilePasswordChanged extends ProfileState {}

class ProfilePhotoUploaded extends ProfileState {
  final String photoUrl;

  ProfilePhotoUploaded(this.photoUrl);
}

class ProfileOrdersLoaded extends ProfileState {
  final List<Map<String, dynamic>> orders;

  ProfileOrdersLoaded(this.orders);
}

class OrderDetailsLoaded extends ProfileState {
  final Map<String, dynamic> orderDetails;

  OrderDetailsLoaded(this.orderDetails);
}

class ProfileSignedOut extends ProfileState {}

// Payment method states
class PaymentMethodsLoaded extends ProfileState {
  final List<CreditCard> cards;
  final String? defaultCardId;

  PaymentMethodsLoaded(this.cards, this.defaultCardId);
}

class PaymentMethodAdded extends ProfileState {
  final CreditCard card;

  PaymentMethodAdded(this.card);
}

class PaymentMethodDeleted extends ProfileState {}

class DefaultPaymentMethodSet extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
