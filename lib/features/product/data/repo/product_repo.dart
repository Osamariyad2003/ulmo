import 'package:dartz/dartz.dart';
import 'package:ulmo/core/errors/expections.dart';
import 'package:ulmo/core/models/product.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/catagory.dart';
import '../data_source/filter_data_source.dart';
import '../data_source/product_data_source.dart';
import '../models/filter_model.dart';

class ProductsRepo {
  final ProductDataSource productsDataSource;
  final FilterDataSource filterDataSource;

  ProductsRepo(
      {required this.productsDataSource, required this.filterDataSource});

  Future<List<Category>> fetchMainCategories() async {
    try {
      return await filterDataSource.fetchParentCategories();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Product>> fetchMainProducts(String categoryId) async {
    try {
      return await productsDataSource.fetchCategoryProducts(categoryId);
    } catch (error) {
      print(error);
      throw FireBaseException(message: 'Error : ${error.toString()}');
    }
  }

  Future<List<Product>> getFilteredProducts(FilterOptions filter) {
    return filterDataSource.fetchFilteredProducts(filter);
  }

  Future<List<Product>> getProductsByIds(List<String> ids) async {
    try {
      return await productsDataSource.fetchProductsByIds(ids);
    } catch (error) {
      print(error);
      throw FireBaseException(
          message: 'Error fetching products by IDs: ${error.toString()}');
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      return await productsDataSource.fetchProductById(id);
    } catch (error) {
      print(error);
      throw FireBaseException(
          message: 'Error fetching product by ID: ${error.toString()}');
    }
  }
}
