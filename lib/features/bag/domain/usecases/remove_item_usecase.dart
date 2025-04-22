import '../../data/repo/bag_repo.dart';

class RemoveItemFromBagUseCase {
  final BagRepositoryImpl repository;

  RemoveItemFromBagUseCase(this.repository);

  void call(String productId) {
    repository.removeItem(productId);
  }
}
