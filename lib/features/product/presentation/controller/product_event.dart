import '../../../../core/models/product.dart';
import '../../data/models/filter_model.dart';

abstract class ProductEvent {}

class LoadProductsEvent extends ProductEvent {
  final String categoryId;
  LoadProductsEvent(this.categoryId);
}

class LoadFilteredCategoriesEvent extends ProductEvent {}
class LoadFilteredProductsEvent extends ProductEvent {
  final FilterOptions filterOptions;

  LoadFilteredProductsEvent(this.filterOptions);
}


class ToggleCategoryEvent extends ProductEvent {
  final String category;
  ToggleCategoryEvent(this.category);
  
}

class ClearSelectionEvent extends ProductEvent {}

class LoadFavorites extends ProductEvent {}


class AddToFavorite extends ProductEvent {
  final Product product;

  AddToFavorite(this.product);
}

class RemoveFromFavorite extends ProductEvent {
  final String productId;

  RemoveFromFavorite(this.productId);
}