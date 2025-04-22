import '../../data/repo/bag_repo.dart';

class UpdateBagItemQuantityUseCase {
  final BagRepositoryImpl repository;

  UpdateBagItemQuantityUseCase(this.repository);

  void call(String productId, int quantity) {
    repository.updateQuantity(productId, quantity);
  }
}
