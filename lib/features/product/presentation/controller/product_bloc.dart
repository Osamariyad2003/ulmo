import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/core/models/catagory.dart';
import 'package:ulmo/features/categories/presentation/controller/category_event.dart';
import 'package:ulmo/features/product/domain/usecases/fetch_products.dart';
import 'package:ulmo/features/product/presentation/controller/product_event.dart';
import 'package:ulmo/features/product/presentation/controller/product_state.dart';

import '../../../../core/models/product.dart';
import '../../domain/usecases/fetch_all_products.dart';
import '../../domain/usecases/filter_usecase.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchProductsUseCase fetchProductsUseCase;
  final FilterProductsUseCase filterProductsUseCase;
  final FetchCategoriesFilterUseCase fetchCategoriesFilterUseCase;

  List<Category> categories = [];
  List<Product> products = []; // ✅ Exposed product list for FavoriteBloc
  Set<String> selectedcat = {};

  ProductBloc(
      this.fetchProductsUseCase,
      this.filterProductsUseCase,
      this.fetchCategoriesFilterUseCase,
      ) : super(ProductLoading()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<LoadFilteredProductsEvent>(_onLoadFilteredProducts);

    on<LoadFilteredCategoriesEvent>((event, emit) async {
      try {
        emit(CategoryLoading());
        categories = await fetchCategoriesFilterUseCase.call();
        selectedcat.addAll(categories.map((category) => category.name));
        emit(CategoryLoaded(categories: categories, selectedCategories: selectedcat));
      } catch (e) {
        emit(CategoryError(message: e.toString()));
      }
    });
  }

  Future<void> _onLoadProducts(
      LoadProductsEvent event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());
    try {
      final result = await fetchProductsUseCase.call(event.categoryId);
      products = result; // ✅ Store for external access
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadFilteredProducts(
      LoadFilteredProductsEvent event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductFilterLoading());
    try {
      final filtered = await filterProductsUseCase(event.filterOptions);
      emit(ProductFilterLoaded(filtered));
    } catch (e) {
      emit(ProductFilterError(e.toString()));
    }
  }
}
