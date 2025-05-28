import '../../data/repo/profile_repo.dart';

class DeletePaymentMethodUseCase {
  final ProfileRepo profileRepo;

  DeletePaymentMethodUseCase(this.profileRepo);

  Future<void> call(String cardId) async {
    await profileRepo.deletePaymentMethod(cardId);
  }
}
