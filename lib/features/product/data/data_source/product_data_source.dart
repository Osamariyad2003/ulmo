import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulmo/core/models/product.dart';

import '../../../../core/errors/expections.dart';

class ProductDataSource {
  Future<List<Product>> fetchCategoryProducts(String categoryId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw FireBaseException(
          message: "No Products found in Firestore",
        );
      }

      final products = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('price')) {
          if (data['price'] is String) {
            data['price'] = double.tryParse(data['price']) ?? 0.0;
          } else if (data['price'] is int) {
            data['price'] = (data['price'] as int).toDouble();
          } else if (data['price'] is! double) {
            data['price'] = 0.0;
          }
        }

        return Product.fromMap(data);
      }).toList();

      return products;

    } catch (error) {
      throw FireBaseException(
        message: 'Error fetching products: ${error.toString()}',
      );
    }
  }
}

