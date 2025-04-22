import 'package:flutter/material.dart';

class DeliveryInfo {
  final String address;
  final double lat;
  final double lng;
  final String method;
  final DateTime date;
  final TimeOfDay time;

  DeliveryInfo({
    required this.address,
    required this.lat,
    required this.lng,
    required this.method,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'lat': lat,
      'lng': lng,
      'method': method,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
    };
  }
}