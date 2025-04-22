
import 'package:ulmo/features/product/data/repo/product_repo.dart';

import '../../../../core/models/catagory.dart';

class FetchCategoriesFilterUseCase{
  final ProductsRepo productsRepo;
  FetchCategoriesFilterUseCase(this.productsRepo);
  Future<List<Category>> call() async{
    return await productsRepo.fetchMainCategories();
  }
}