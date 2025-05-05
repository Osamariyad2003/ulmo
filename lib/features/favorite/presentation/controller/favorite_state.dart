import '../../../../core/models/product.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteUpdated extends FavoriteState {
  final List<Product> favorites;
  FavoriteUpdated(this.favorites);
}

class FavoriteIdsUpdated extends FavoriteState {
  final List<String> ids;

  FavoriteIdsUpdated(this.ids);
}

class FavoriteProductsNotFound extends FavoriteState {
  final List<String> ids;

  FavoriteProductsNotFound(this.ids);
}
