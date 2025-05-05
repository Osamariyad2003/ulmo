import '../../../../core/models/catagory.dart';
import '../../../../core/models/product.dart';

abstract class ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}

class ProductFilterLoading extends ProductState {}

class ProductFilterLoaded extends ProductState {
  final List<Product> products;

  ProductFilterLoaded(this.products);
}

class ProductFilterError extends ProductState {
  final String message;

  ProductFilterError(this.message);
}

class CategoryLoading extends ProductState {}

class CategoryLoaded extends ProductState {
  final List<Category> categories;
  final Set<String> selectedCategories;

  CategoryLoaded({required this.categories, required this.selectedCategories});
}

class CategoryError extends ProductState {
  final String message;

  CategoryError({required this.message});
}

class FavoriteLoading extends ProductState {}

class FavoriteLoaded extends ProductState {
  final List<Product> favorites;

  FavoriteLoaded(this.favorites);
}
