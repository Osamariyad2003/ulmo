import 'package:ulmo/features/delivery/data/model/delivery_model.dart';

import '../../data/repo/payment_repo.dart';

class PayUseCase {
  final PaymentRepositoryImpl repository;

  PayUseCase(this.repository);

  Future<void> call(DeliveryInfo deliveryInfo) async {
    await repository.pay(deliveryInfo: deliveryInfo);
  }
}
