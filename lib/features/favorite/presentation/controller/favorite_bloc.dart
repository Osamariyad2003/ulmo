import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../../core/models/product.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';




class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final List<Product> allProducts;
  final Box<List<String>> _box = Hive.box<List<String>>('favorite_ids');

  FavoriteBloc(this.allProducts) : super(FavoriteInitial()) {
    on<AddToFavorite>(_onAddToFavorite);
    on<RemoveFromFavorite>(_onRemoveFromFavorite);
    on<LoadFavorites>(_onLoadFavorites);

    add(LoadFavorites());
  }

  Future<void> _onAddToFavorite(AddToFavorite event, Emitter<FavoriteState> emit) async {
    final ids = _getStoredIds();
    final id = event.product.id.toString();

    if (!ids.contains(id)) {
      ids.add(id);
      await _box.put('ids', ids);
    }

    _emitFavorites(emit, ids);
  }

  Future<void> _onRemoveFromFavorite(RemoveFromFavorite event, Emitter<FavoriteState> emit) async {
    final ids = _getStoredIds();
    ids.remove(event.productId.toString());
    await _box.put('ids', ids);

    _emitFavorites(emit, ids);
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<FavoriteState> emit) {
    final ids = _getStoredIds();
    _emitFavorites(emit, ids);
  }

  List<String> _getStoredIds() {
    return List<String>.from(_box.get('ids', defaultValue: <String>[]) ?? []);
  }

  void _emitFavorites(Emitter<FavoriteState> emit, List<String> ids) {
    final favorites = allProducts.where((p) => ids.contains(p.id.toString())).toList();
    print("Favorite IDs: $ids");
    print("Matching products: ${favorites.map((e) => e.id).toList()}");
    emit(FavoriteUpdated(favorites));
  }

  bool isFavorite(String id) {
    final ids = _getStoredIds();
    return ids.contains(id.toString());
  }
}
