import '../../data/models/bag_model.dart';
import '../../data/repo/bag_repo.dart';

class GetBagUseCase {
  final BagRepositoryImpl repository;

  GetBagUseCase(this.repository);

  Future<BagModel> call() async {
    return await repository.getBag();
  }
}
