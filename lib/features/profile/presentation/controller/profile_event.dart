import 'dart:io';

import '../../data/models/credit_card.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> profileData;

  UpdateProfile({required this.profileData});
}

class UploadProfilePhoto extends ProfileEvent {
  final File photo;

  UploadProfilePhoto({required this.photo});
}

class UpdateProfileWithPhoto extends ProfileEvent {
  final Map<String, dynamic> profileData;
  final File photo;

  UpdateProfileWithPhoto({required this.profileData, required this.photo});
}

class ChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  ChangePassword({required this.currentPassword, required this.newPassword});
}

class LoadOrders extends ProfileEvent {}

class LoadOrderDetails extends ProfileEvent {
  final String orderId;

  LoadOrderDetails(this.orderId);
}

class SignOut extends ProfileEvent {}

// Payment method related events
class LoadPaymentMethods extends ProfileEvent {}

class AddPaymentMethod extends ProfileEvent {
  final CreditCard card;

  AddPaymentMethod(this.card);
}

class DeletePaymentMethod extends ProfileEvent {
  final String cardId;

  DeletePaymentMethod(this.cardId);
}

class SetDefaultPaymentMethod extends ProfileEvent {
  final String cardId;

  SetDefaultPaymentMethod(this.cardId);
}
