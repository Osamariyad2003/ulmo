import 'package:flutter/material.dart';
import 'package:ulmo/features/delivery/data/model/delivery_model.dart';

abstract class DeliveryEvent {}

class SetDeliveryAddress extends DeliveryEvent {
  final String address;
  final double lat;
  final double lng;

  SetDeliveryAddress(this.address, this.lat, this.lng);
}

class SetDeliveryMethod extends DeliveryEvent {
  final String method;
  SetDeliveryMethod(this.method);
}

class SetDeliverySchedule extends DeliveryEvent {
  final DateTime? date;
  final TimeOfDay? time;

  SetDeliverySchedule(this.date, this.time);
}

class SaveDeliveryToFirebase extends DeliveryEvent {
  final String userId;
  SaveDeliveryToFirebase(this.userId);
}

class LoadSavedAddresses extends DeliveryEvent {
  final String userId;
  LoadSavedAddresses(this.userId);
}

class SaveNewAddress extends DeliveryEvent {
  final String userId;
  final String address;
  final double lat;
  final double lng;

  SaveNewAddress({
    required this.userId,
    required this.address,
    required this.lat,
    required this.lng,
  });
}

class DeleteSavedAddress extends DeliveryEvent {
  final String addressId;
  DeleteSavedAddress(this.addressId);
}

class SelectSavedAddress extends DeliveryEvent {
  final DeliveryInfo address;
  SelectSavedAddress(this.address);
}
