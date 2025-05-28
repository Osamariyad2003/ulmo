import '../../data/repo/profile_repo.dart';

class SetDefaultPaymentMethodUseCase {
  final ProfileRepo profileRepo;

  SetDefaultPaymentMethodUseCase(this.profileRepo);

  Future<void> call(String cardId) async {
    await profileRepo.setDefaultPaymentMethod(cardId);
  }
}
