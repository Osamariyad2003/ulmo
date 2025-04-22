class CheckoutModel {
  final String deliveryAddress;
  final String deliveryMethod;
  final String paymentMethod;
  final DateTime deliveryTime;
  final double totalAmount;

  CheckoutModel({
    required this.deliveryAddress,
    required this.deliveryMethod,
    required this.paymentMethod,
    required this.deliveryTime,
    required this.totalAmount,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) => CheckoutModel(
    deliveryAddress: json['deliveryAddress'],
    deliveryMethod: json['deliveryMethod'],
    paymentMethod: json['paymentMethod'],
    deliveryTime: DateTime.parse(json['deliveryTime']),
    totalAmount: (json['totalAmount'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'deliveryAddress': deliveryAddress,
    'deliveryMethod': deliveryMethod,
    'paymentMethod': paymentMethod,
    'deliveryTime': deliveryTime.toIso8601String(),
    'totalAmount': totalAmount,
  };
}
