import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ulmo/features/delivery/data/model/delivery_model.dart';
import '../data_source/payment_data_source.dart';

class PaymentRepositoryImpl {
  final PaymentDataSource paymentDataSource;

  PaymentRepositoryImpl({required this.paymentDataSource});

  /// Process a payment using the default payment method or new card
  Future<void> pay({required DeliveryInfo deliveryInfo}) async {
    try {
      await paymentDataSource.processPayment(deliveryInfo: deliveryInfo);
    } on StripeException catch (e) {
      final code = e.error.code;
      final message =
          e.error.localizedMessage ?? 'An unknown error occurred with Stripe.';
      print('❌ StripeException: [$code] $message');
      throw Exception('Payment failed: $message');
    } on PlatformException catch (e) {
      print('❌ PlatformException: ${e.code} - ${e.message}');
      throw Exception('A platform error occurred: ${e.message}');
    } catch (e) {
      print('❌ Unknown error during payment: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  /// Process a payment using a saved payment method
  Future<void> payWithSavedMethod({
    required String paymentMethodId,
    required DeliveryInfo deliveryInfo,
  }) async {
    try {
      await paymentDataSource.processPayment(
        savedCardId: paymentMethodId,
        deliveryInfo: deliveryInfo,
      );
    } on StripeException catch (e) {
      final code = e.error.code;
      final message =
          e.error.localizedMessage ?? 'An unknown error occurred with Stripe.';
      print('❌ StripeException with saved method: [$code] $message');
      throw Exception('Payment failed: $message');
    } on PlatformException catch (e) {
      print('❌ PlatformException: ${e.code} - ${e.message}');
      throw Exception('A platform error occurred: ${e.message}');
    } catch (e) {
      print('❌ Unknown error during payment: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
}
