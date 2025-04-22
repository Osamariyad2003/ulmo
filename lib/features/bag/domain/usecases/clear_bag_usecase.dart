import '../../data/repo/bag_repo.dart';

class ClearBagUseCase {
  final BagRepositoryImpl repository;

  ClearBagUseCase(this.repository);

  void call() {
    repository.clear();
  }
}
