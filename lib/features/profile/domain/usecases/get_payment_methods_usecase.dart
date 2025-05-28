import '../../data/models/credit_card.dart';
import '../../data/repo/profile_repo.dart';

class GetPaymentMethodsUseCase {
  final ProfileRepo profileRepo;

  GetPaymentMethodsUseCase(this.profileRepo);

  Future<List<CreditCard>> call() async {
    return await profileRepo.getPaymentMethods();
  }
}
