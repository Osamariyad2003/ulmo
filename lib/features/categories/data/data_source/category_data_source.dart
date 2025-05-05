import 'package:dartz/dartz.dart' as doc;
import 'package:ulmo/core/errors/expections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/models/catagory.dart';

class CategoryDataSource {
  Future<List<Category>> fetchParentCategories() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('category')
              .where('parentId', isEqualTo: 'root')
              .get();

      if (querySnapshot.docs.isEmpty) {
        throw FireBaseException(message: "No categories found in Firestore");
      }

      final categories =
          querySnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Category.fromMap(data, doc.id);
          }).toList();

      return categories;
    } catch (error) {
      throw FireBaseException(
        message: 'Error fetching categories: ${error.toString()}',
      );
    }
  }

  Future<List<Category>> fetchChildCategories(String parentId) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('category')
              .where('parentId', isEqualTo: parentId)
              .get();

      if (querySnapshot.docs.isEmpty) {
        throw FireBaseException(
          message: "No child categories found for parentId: $parentId",
        );
      }

      final childCategories =
          querySnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Category.fromMap(data, doc.id);
          }).toList();

      return childCategories;
    } catch (error) {
      throw FireBaseException(
        message: 'Error fetching child categories: ${error.toString()}',
      );
    }
  }

  Future<List<Category>> searchCategories(String parentId, String query) async {
    try {
      // First, fetch all child categories for the parent
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('category')
              .where('parentId', isEqualTo: parentId)
              .get();

      // Even if there are no categories, return an empty list instead of throwing an exception
      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      final allCategories =
          querySnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Category.fromMap(data, doc.id);
          }).toList();

      if (query.isEmpty || query.trim().isEmpty) {
        return allCategories;
      }

      // Filter categories based on the search query (case-insensitive)
      final lowercaseQuery = query.toLowerCase().trim();
      final filteredCategories =
          allCategories
              .where(
                (category) =>
                    category.name.toLowerCase().contains(lowercaseQuery),
              )
              .toList();

      // For debugging
      print(
        'Search query: "$query", Found ${filteredCategories.length} results',
      );

      return filteredCategories;
    } catch (error) {
      print('Search error: ${error.toString()}');
      // Return empty list instead of throwing an exception to prevent crashes
      return [];
    }
  }
}
