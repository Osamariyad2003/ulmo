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

  factory BagItemModel.fromJson(Map<String, dynamic> json) => BagItemModel(
    productId: json['productId'],
    name: json['name'],
    imageUrl: json['imageUrl'],
    price: (json['price'] as num).toDouble(),
    quantity: json['quantity'] ?? 1,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'imageUrl': imageUrl,
    'price': price,
    'quantity': quantity,
  };
}
