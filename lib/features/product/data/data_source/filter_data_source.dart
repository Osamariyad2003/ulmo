import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/expections.dart';
import '../../../../core/models/catagory.dart';
import '../../../../core/models/product.dart';
import '../models/filter_model.dart';


class FilterDataSource {

  FilterDataSource();

  Future<List<Category>> fetchParentCategories() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('category')
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw FireBaseException(
          message: "No categories found in Firestore",
        );
      }

      final categories = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Category.fromMap(data,doc.id);
      }).toList();

      return categories;
    } catch (error) {
      throw FireBaseException(
        message: 'Error fetching categories: ${error.toString()}',
      );
    }
  }


  Future<List<Product>> fetchFilteredProducts(FilterOptions filter) async {
    CollectionReference productsRef = FirebaseFirestore.instance.collection('products');
    Query query = productsRef;
    if (filter.categoryId != null && filter.categoryId!.isNotEmpty) {
      query = query.where('categoryId', isEqualTo: filter.categoryId);
    }
    if (filter.minPrice != null) {
      query = query.where('measurements.price', isGreaterThanOrEqualTo: filter.minPrice);
    }
    if (filter.maxPrice != null) {
      query = query.where('measurements.price', isLessThanOrEqualTo: filter.maxPrice);
    }

    if (filter.mainMaterial != null && filter.mainMaterial!.isNotEmpty) {
      query = query.where('composition.mainMaterial', isEqualTo: filter.mainMaterial);
    }
    query = query.orderBy(
      'measurements.price',
      descending: filter.sortByPriceDescending,
    );
    final querySnapshot = await query.get();

    return querySnapshot.docs.map((doc) {
      return Product.fromMap(doc as Map<String, dynamic>);
    }).toList();
  }
}
