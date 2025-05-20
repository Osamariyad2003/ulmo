import 'package:flutter/material.dart';
import 'package:ulmo/features/delivery/data/model/delivery_model.dart';

abstract class DeliveryState {
  const DeliveryState();
}

// Add new state for saved addresses
class SavedAddressesLoaded extends DeliveryState {
  final List<DeliveryInfo> addresses;
  const SavedAddressesLoaded(this.addresses);
}

class DeliveryInitial extends DeliveryState {
  const DeliveryInitial();
}

class DeliveryLoading extends DeliveryState {
  const DeliveryLoading();
}

class DeliveryError extends DeliveryState {
  final String message;

  const DeliveryError(this.message);
}

class DeliverySelected extends DeliveryState {
  final String address;
  final double lat;
  final double lng;
  final String method;
  final DateTime date;
  final TimeOfDay time;
  final bool saved;

  const DeliverySelected({
    required this.address,
    required this.lat,
    required this.lng,
    required this.method,
    required this.date,
    required this.time,
    this.saved = false,
  });

  DeliverySelected copyWith({
    String? address,
    double? lat,
    double? lng,
    String? method,
    DateTime? date,
    TimeOfDay? time,
    bool? saved,
  }) {
    return DeliverySelected(
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      method: method ?? this.method,
      date: date ?? this.date,
      time: time ?? this.time,
      saved: saved ?? this.saved,
    );
  }
}
