import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ulmo/core/helpers/stripe_services.dart';
import 'package:ulmo/core/models/payment_model/payment_intent_input_model.dart';
import 'package:ulmo/features/bag/data/models/bag_model.dart';
import 'package:ulmo/features/delivery/data/model/delivery_model.dart';
import 'package:uuid/uuid.dart';
import 'bag_data_source.dart';

class PaymentDataSource {
  final BagDataSource bagSource;
  final StripeServices stripeServises;
  final String stripeCustomerId;
  final FirebaseFirestore _firestore;

  PaymentDataSource({
    required this.bagSource,
    required this.stripeServises,
    required this.stripeCustomerId,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Process a payment using Stripe
  Future<void> processPayment({
    String? savedCardId,
    required DeliveryInfo deliveryInfo,
  }) async {
    final bag = bagSource.getBag();
    final totalAmount = bag.total;

    if (totalAmount <= 0) {
      throw Exception("Bag is empty. Cannot process payment.");
    }

    final paymentInput = PaymentIntentInputModel(
      amount: (totalAmount * 100).toString(), // Convert to cents for Stripe
      currency: 'usd',
      customerId: stripeCustomerId,
    );

    try {
      String paymentIntentId;
      if (savedCardId != null) {
        paymentIntentId = await _processPaymentWithSavedCard(
          paymentIntentInputModel: paymentInput,
          savedCardId: savedCardId,
        );
      } else {
        final paymentResult = await stripeServises.makePayment(
          paymentIntentInputModel: paymentInput,
        );
        paymentIntentId = paymentResult.id;
      }

      // Add order to Firebase with delivery info
      await _saveOrderToFirebase(
        bag: bag,
        totalAmount: totalAmount,
        paymentIntentId: paymentIntentId,
        deliveryInfo: deliveryInfo,
      );

      // Clear the bag after successful payment and order creation
      bagSource.clear();
      print("Payment successful, order saved to Firebase, and bag cleared.");
    } catch (e) {
      print("Payment or order creation failed: $e");
      rethrow;
    }
  }

  /// Save order to Firebase
  Future<void> _saveOrderToFirebase({
    required BagModel bag,
    required double totalAmount,
    required String paymentIntentId,
    required DeliveryInfo deliveryInfo,
  }) async {
    try {
      final orderId = const Uuid().v4();

      await _firestore.collection('orders').doc(orderId).set({
        'id': orderId,
        'customerId': stripeCustomerId,
        'items':
            bag.items
                .map(
                  (item) => {
                    'productId': item.productId,
                    'quantity': item.quantity,
                    'price': item.price,
                    'title': item.name,
                    'image': item.imageUrl,
                  },
                )
                .toList(),
        'delivery': deliveryInfo.toMap(),
        'totalAmount': totalAmount,
        'paymentIntentId': paymentIntentId,
        'orderDate': FieldValue.serverTimestamp(),
        'status': 'processing',
        'estimatedDeliveryDate': deliveryInfo.date.toIso8601String(),
      });
    } catch (e) {
      print("Error saving order to Firebase: $e");
      rethrow;
    }
  }

  /// Internal method to process payment with a saved card
  Future<String> _processPaymentWithSavedCard({
    required PaymentIntentInputModel paymentIntentInputModel,
    required String savedCardId,
  }) async {
    try {
      final paymentIntent = await stripeServises.createPaymentIntent(
        paymentIntentInputModel,
      );

      final paymentResult = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntent.clientSecret!,
        data: PaymentMethodParams.cardFromMethodId(
          paymentMethodData: PaymentMethodDataCardFromMethod(
            paymentMethodId: savedCardId,
          ),
        ),
      );

      return paymentResult.id;
    } catch (e) {
      rethrow;
    }
  }
}
