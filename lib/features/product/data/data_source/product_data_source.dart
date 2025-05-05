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
        throw FireBaseException(message: "No Products found in Firestore");
      }

      final products = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Add the document ID as the product ID
        data['id'] = doc.id;

        data['id'] = doc.id;

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

  Future<List<Product>> fetchProductsByIds(List<String> ids) async {
    try {
      if (ids.isEmpty) return [];

      const int batchSize = 10;
      List<Product> allProducts = [];

      for (int i = 0; i < ids.length; i += batchSize) {
        final end = (i + batchSize < ids.length) ? i + batchSize : ids.length;
        final batchIds = ids.sublist(i, end);

        final querySnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where(FieldPath.documentId, whereIn: batchIds)
            .get();

        final batchProducts = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          // Add the document ID as the product ID
          data['id'] = doc.id;

          // Process data similar to your existing code
          if (data.containsKey('price')) {
            if (data['price'] is String) {
              data['price'] = double.tryParse(data['price']) ?? 0.0;
            } else if (data['price'] is int) {
              data['price'] = (data['price'] as int).toDouble();
            } else if (data['price'] is! double) {
              data['price'] = 0.0;
            }
          }

          return Product.fromMap(data,
              isFav: true); // Mark as favorite by default
        }).toList();

        allProducts.addAll(batchProducts);
      }

      return allProducts;
    } catch (error) {
      throw FireBaseException(
        message: 'Error fetching products by IDs: ${error.toString()}',
      );
    }
  }

  Future<Product> fetchProductById(String id) async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('products').doc(id).get();

      if (!docSnapshot.exists) {
        throw FireBaseException(message: "Product not found");
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      data['id'] = docSnapshot.id;

      if (data.containsKey('price')) {
        if (data['price'] is String) {
          data['price'] = double.tryParse(data['price']) ?? 0.0;
        } else if (data['price'] is int) {
          data['price'] = (data['price'] as int).toDouble();
        } else if (data['price'] is! double) {
          data['price'] = 0.0;
        }
      }

      return Product.fromMap(data, isFav: true); // Mark as favorite by default
    } catch (error) {
      throw FireBaseException(
        message: 'Error fetching product: ${error.toString()}',
      );
    }
  }
}
