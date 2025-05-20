import 'package:flutter/material.dart';

class DeliveryInfo {
  final String userId;
  final String address;
  final double lat;
  final double lng;
  final String method;
  final DateTime date;
  final TimeOfDay time;

  DeliveryInfo({
    required this.userId,
    required this.address,
    required this.lat,
    required this.lng,
    required this.method,
    required this.date,
    required this.time,
  });

  factory DeliveryInfo.fromMap(Map<String, dynamic> map) {
    final timeParts = (map['time'] as String).split(':');
    return DeliveryInfo(
      userId: map['userId'] ?? '',
      address: map['address'] ?? '',
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
      method: map['method'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'address': address,
      'lat': lat,
      'lng': lng,
      'method': method,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
    };
  }
}
