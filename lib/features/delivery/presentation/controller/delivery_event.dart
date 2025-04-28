import 'package:flutter/material.dart';

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
