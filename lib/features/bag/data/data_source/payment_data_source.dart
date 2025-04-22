import 'package:ulmo/core/helpers/stripe_services.dart';

import '../../../../core/models/payment_model/payment_intent_input_model.dart';
import 'bag_data_source.dart';

class PaymentDataSource {
  final BagDataSource bagSource;
  final StripeServices stripeServises;
  final String stripeCustomerId;

  PaymentDataSource({
    required this.bagSource,
    required this.stripeServises,
    required this.stripeCustomerId,
  });

  Future<void> processPayment() async {
    final bag = bagSource.getBag();
    final totalAmount = bag.total;

    if (totalAmount <= 0) {
      throw Exception("Bag is empty. Cannot process payment.");
    }

    final paymentInput = PaymentIntentInputModel(
      amount: (totalAmount * 100).toString(),
      currency: 'usd',
      customerId: stripeCustomerId,
    );

    try {
      await stripeServises.makePayment(paymentIntentInputModel: paymentInput);
      bagSource.clear();
      print("Payment successful and bag cleared.");
    } catch (e) {
      print("Payment failed: $e");
      rethrow;
    }
  }
}
