import '../../../../core/models/product.dart';

abstract class FavoriteEvent {}

class AddToFavorite extends FavoriteEvent {
  final Product product;
  AddToFavorite(this.product);
}

class RemoveFromFavorite extends FavoriteEvent {
  final String productId;
  RemoveFromFavorite(this.productId);
}

class LoadFavorites extends FavoriteEvent {}

class ToggleFavorite extends FavoriteEvent {
  final String productId;

  ToggleFavorite(this.productId);
}

class UpdateFavoriteProducts extends FavoriteEvent {
  final List<dynamic> products;

  UpdateFavoriteProducts(this.products);
}
