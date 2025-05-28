import '../../data/models/credit_card.dart';
import '../../data/repo/profile_repo.dart';

class SavePaymentMethodUseCase {
  final ProfileRepo profileRepo;

  SavePaymentMethodUseCase(this.profileRepo);

  Future<CreditCard> call(CreditCard card) async {
    await profileRepo.addPaymentMethod(card);
    // Return the card with a possibly updated ID (in case the repo generates one)
    return card;
  }
}
