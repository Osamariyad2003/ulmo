import '../../../../core/models/product.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteUpdated extends FavoriteState {
  final List<Product> favorites;
  FavoriteUpdated(this.favorites);
}
