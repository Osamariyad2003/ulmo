class BagItemModel {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  BagItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  factory BagItemModel.fromJson(Map<String, dynamic> json) {
    return BagItemModel(
      productId: json['productId'] ?? '',
      name: json['name'] ?? 'Unknown Product',
      imageUrl: json['imageUrl'] ?? '',
      price:
          json['price'] != null
              ? (json['price'] is num
                  ? (json['price'] as num).toDouble()
                  : double.tryParse(json['price'].toString()) ?? 0.0)
              : 0.0,
      quantity:
          json['quantity'] != null
              ? (json['quantity'] is num
                  ? (json['quantity'] as num).toInt()
                  : int.tryParse(json['quantity'].toString()) ?? 1)
              : 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'imageUrl': imageUrl,
    'price': price,
    'quantity': quantity,
  };

  // Add equality method to compare bag items
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BagItemModel) return false;
    return other.productId.trim().toLowerCase() ==
        productId.trim().toLowerCase();
  }

  @override
  int get hashCode => productId.trim().toLowerCase().hashCode;

  // Create a copy with modified properties
  BagItemModel copyWith({
    String? productId,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
  }) {
    return BagItemModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  // Check if item is valid
  bool get isValid {
    // Debug validation info
    print('BagItem validation:');
    print('- productId: "$productId", isEmpty: ${productId.isEmpty}');
    print('- name: "$name", isEmpty: ${name.isEmpty}');
    print('- price: $price, isPositive: ${price > 0}');
    print('- quantity: $quantity, isPositive: ${quantity > 0}');

    return productId.isNotEmpty && name.isNotEmpty && price > 0 && quantity > 0;
  }

  @override
  String toString() =>
      'BagItem(id: $productId, name: $name, price: \$$price, qty: $quantity)';
}
