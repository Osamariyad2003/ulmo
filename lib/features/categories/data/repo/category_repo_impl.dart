import '../../../../core/models/catagory.dart';
import '../data_source/category_data_source.dart';

class CategoriesRepo {
  final CategoryDataSource categoryDataSource;

  CategoriesRepo({required this.categoryDataSource});

  Future<List<Category>> fetchMainCategories() async {
    try {
      return await categoryDataSource.fetchParentCategories();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Category>> fetchChildCategories(String parentId) async {
    try {
      return await categoryDataSource.fetchChildCategories(parentId);
    } catch (error) {
      rethrow; // or throw a custom exception
    }
  }

  Future<List<Category>> searchCategories(String parentId, String query) async {
    try {
      return await categoryDataSource.searchCategories(parentId, query);
    } catch (error) {
      rethrow;
    }
  }
}
