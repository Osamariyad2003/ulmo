import 'package:flutter/material.dart';

class DeliveryState {
  final String? address;
  final double? lat;
  final double? lng;
  final String? method;
  final DateTime? date;
  final TimeOfDay? time;
  final bool saved;
  final String? error;

  DeliveryState({
    this.address,
    this.lat,
    this.lng,
    this.method,
    this.date,
    this.time,
    this.saved = false,
    this.error,
  });

  DeliveryState copyWith({
    String? address,
    double? lat,
    double? lng,
    String? method,
    DateTime? date,
    TimeOfDay? time,
    bool? saved,
    String? error,
  }) {
    return DeliveryState(
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      method: method ?? this.method,
      date: date ?? this.date,
      time: time ?? this.time,
      saved: saved ?? this.saved,
      error: error,
    );
  }
}
