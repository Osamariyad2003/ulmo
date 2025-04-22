import 'package:ulmo/features/product/data/repo/product_repo.dart';

import '../../../../core/models/product.dart';
import '../../data/models/filter_model.dart';

class FilterProductsUseCase {
  final ProductsRepo repository;

  FilterProductsUseCase(this.repository);

  Future<List<Product>> call(FilterOptions filter) {
    return repository.getFilteredProducts(filter);
  }
}