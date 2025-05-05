import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:ulmo/features/product/data/repo/product_repo.dart';

import '../../../../core/models/product.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final List<Product> allProducts;
  final List<Product> favProducts = [];
  final ProductsRepo productRepository;
  final Box<List<String>> _box = Hive.box<List<String>>('favorite_ids');

  FavoriteBloc({
    required this.productRepository,
    this.allProducts = const [], // This can now be optional
  }) : super(FavoriteInitial()) {
    on<AddToFavorite>(_onAddToFavorite);
    on<RemoveFromFavorite>(_onRemoveFromFavorite);
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
    on<UpdateFavoriteProducts>(_onUpdateFavoriteProducts);

    add(LoadFavorites());
  }

  Future<void> _onAddToFavorite(
    AddToFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    final ids = _getStoredIds();
    final id = event.product.id.toString();

    if (!ids.contains(id)) {
      ids.add(id);
      await _box.put('ids', ids);
      print("Added product ID $id to favorites. New favorites: $ids");
    }

    _emitFavorites(emit, ids);
  }

  Future<void> _onRemoveFromFavorite(
    RemoveFromFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    final ids = _getStoredIds();
    ids.remove(event.productId.toString());
    await _box.put('ids', ids);
    print(
      "Removed product ID ${event.productId} from favorites. New favorites: $ids",
    );

    _emitFavorites(emit, ids);
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    final ids = _getStoredIds();
    final id = event.productId.toString();

    if (ids.contains(id)) {
      ids.remove(id);
      print("Toggle OFF: Removed $id from favorites");
    } else {
      ids.add(id);
      print("Toggle ON: Added $id to favorites");
    }

    await _box.put('ids', ids);
    _emitFavorites(emit, ids);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    final ids = _getStoredIds();

    // First emit the IDs for quick status checks
    emit(FavoriteIdsUpdated(ids));

    if (ids.isEmpty) {
      emit(FavoriteUpdated([])); // Empty favorites
      return;
    }

    // Try to find products in the allProducts list first (for performance)
    final cachedFavorites =
        allProducts.where((p) => ids.contains(p.id.toString())).toList();

    if (cachedFavorites.length == ids.length) {
      // All favorites were found in the local cache
      emit(FavoriteUpdated(cachedFavorites));
      return;
    }

    try {
      final products = await productRepository.getProductsByIds(ids);

      if (products.isEmpty && ids.isNotEmpty) {
        emit(FavoriteProductsNotFound(ids));
      } else {
        emit(FavoriteUpdated(products));
      }
    } catch (error) {
      // Handle error
      print("Error loading favorites: $error");
      emit(FavoriteProductsNotFound(ids));
    }
  }

  void _onUpdateFavoriteProducts(
      UpdateFavoriteProducts event, Emitter<FavoriteState> emit) {
    if (event.products.isEmpty) {
      emit(FavoriteUpdated([]));
      return;
    }

    // Create a new non-final list to store the updated products
    List<Product> updatedProducts = [];

    // Process each product and add it to our list
    for (var product in event.products) {
      if (product is Product) {
        try {
          updatedProducts.add(product.copyWith(isFav: true));
        } catch (e) {
          print("Warning: could not set isFav on product: $e");
          updatedProducts.add(product);
        }
      } else {
        updatedProducts.add(product);
      }
    }

    print("Updated favorites with ${updatedProducts.length} products");
    emit(FavoriteUpdated(updatedProducts));
  }

  List<String> _getStoredIds() {
    return List<String>.from(_box.get('ids', defaultValue: <String>[]) ?? []);
  }

  void _emitFavorites(Emitter<FavoriteState> emit, List<String> ids) {
    // First emit the IDs for quick status checks
    emit(FavoriteIdsUpdated(ids));

    // Then emit the actual products (this might be empty if allProducts doesn't
    // contain the favorited items)
    final favorites =
        allProducts.where((p) => ids.contains(p.id.toString())).toList();
    print("Favorite IDs: $ids");
    print("Found matching products: ${favorites.length}");
    print("Matching product IDs: ${favorites.map((e) => e.id).toList()}");

    // If no products were found but we have IDs, emit a special state
    if (favorites.isEmpty && ids.isNotEmpty) {
      print("Warning: No matching products found for favorite IDs");
      emit(FavoriteProductsNotFound(ids));
    } else {
      emit(FavoriteUpdated(favorites));
    }
  }

  bool isFavorite(String id) {
    final ids = _getStoredIds();
    return ids.contains(id.toString());
  }

  List<String> get favoriteIds => _getStoredIds();
}
