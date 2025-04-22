import 'bag_item_model.dart';

class BagModel {
  final List<BagItemModel> items;
  final double total;
  final String? promoCode;

  BagModel({
    required this.items,
    required this.total,
    this.promoCode,
  });

  factory BagModel.fromJson(Map<String, dynamic> json) => BagModel(
    items: (json['items'] as List<dynamic>)
        .map((item) => BagItemModel.fromJson(item))
        .toList(),
    total: (json['total'] as num).toDouble(),
    promoCode: json['promoCode'],
  );

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'total': total,
    'promoCode': promoCode,
  };

  BagModel copyWith({
    List<BagItemModel>? items,
    double? total,
    String? promoCode,
  }) {
    return BagModel(
      items: items ?? this.items,
      total: total ?? this.total,
      promoCode: promoCode ?? this.promoCode,
    );
  }
}
