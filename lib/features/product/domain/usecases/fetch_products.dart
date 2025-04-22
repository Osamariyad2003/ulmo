import 'package:ulmo/core/models/product.dart';
import 'package:ulmo/features/product/data/repo/product_repo.dart';

class FetchProductsUseCase{
  final  ProductsRepo productsRepo;
  FetchProductsUseCase(this.productsRepo);
  Future<List<Product>> call(String categoryId) async{
    return await productsRepo.fetchMainProducts(categoryId);
  }
}