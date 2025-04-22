import 'package:cloud_firestore/cloud_firestore.dart';


class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final int stock;
  final List<String> imageUrls;
  final String categoryId;
  final List<String>? variants;
  final DateTime createdAt;
  final Measurements measurements;
  final Composition composition;

  bool isFav;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrls,
    required this.categoryId,
    this.variants,
    required this.createdAt,
    required this.measurements,
    required this.composition,
    this.isFav = false,
  });

  factory Product.fromMap(Map<String, dynamic> data, {bool isFav = false}) {
    double parsedPrice = 0.0;

    try {
      if (data['price'] is int) {
        parsedPrice = (data['price'] as int).toDouble();
      } else if (data['price'] is double) {
        parsedPrice = data['price'];
      } else if (data['price'] is String) {
        parsedPrice = double.tryParse(data['price']) ?? 0.0;
      }
    } catch (e) {
      parsedPrice = 0.0; // Fallback if parsing fails
    }

    return Product(
      id: data['id'] ?? '',
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      price: (data['price'])?.toDouble() ?? 0.0,
      stock: (data['stock'] )?.toInt() ?? 0,
      imageUrls: data['imageUrls'] != null ? List<String>.from(data['imageUrls']) : [],
      categoryId: data['categoryId'] ?? '',
      variants: data['variants'] != null ? List<String>.from(data['variants']) : [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      measurements: Measurements.fromMap(data['measurements'] ?? {}),
      composition: Composition.fromMap(data['composition'] ?? {}),
      isFav: isFav,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'imageUrls': imageUrls,
      'categoryId': categoryId,
      'variants': variants,
      'createdAt': Timestamp.fromDate(createdAt),
      'measurements': measurements.toMap(),
      'composition': composition.toMap(),
    };
  }
}

class Measurements {
  final double height;
  final double width;
  final double depth;
  final double weight;

  Measurements({
    required this.height,
    required this.width,
    required this.depth,
    required this.weight,
  });

  factory Measurements.fromMap(Map<String, dynamic> data) {
    double parseToDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Measurements(
      height: parseToDouble(data['height']),
      width: parseToDouble(data['width']),
      depth: parseToDouble(data['depth']),
      weight: parseToDouble(data['weight']),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'width': width,
      'depth': depth,
      'weight': weight,
    };
  }
}

class Composition {
  final String mainMaterial;
  final String secondaryMaterial;

  Composition({
    required this.mainMaterial,
    required this.secondaryMaterial,
  });

  factory Composition.fromMap(Map<String, dynamic> data) {
    return Composition(
      mainMaterial: data['mainMaterial'] ?? 'N/A',
      secondaryMaterial: data['secondaryMaterial'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mainMaterial': mainMaterial,
      'secondaryMaterial': secondaryMaterial,
    };
  }
}
