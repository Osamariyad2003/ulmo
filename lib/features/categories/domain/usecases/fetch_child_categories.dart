import 'package:ulmo/core/models/catagory.dart';
import '../../data/repo/category_repo_impl.dart';

class FetchChildCategoriesUseCase{
  final CategoriesRepo categoriesRepo;
  FetchChildCategoriesUseCase(this.categoriesRepo);
  Future<List<Category>> call({required String parentId}) async{
    return await categoriesRepo.fetchChildCategories(parentId);
  }
}