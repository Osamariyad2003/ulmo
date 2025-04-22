import '../../data/repo/payment_repo.dart';

class PayUseCase {
  final PaymentRepositoryImpl repository;

  PayUseCase(this.repository);

  Future<void> call() async {
    await repository.pay();
  }
}
