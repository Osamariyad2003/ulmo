import '../../data/models/bag_item_model.dart';
import '../../data/repo/bag_repo.dart';

class AddItemToBagUseCase {
  final BagRepositoryImpl repository;

  AddItemToBagUseCase(this.repository);

  void call(BagItemModel item) {
    repository.addItem(item);
  }
}
