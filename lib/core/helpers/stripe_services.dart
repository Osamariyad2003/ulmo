import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../models/payment_model/initPaymentSheetInputModel.dart';
import '../models/payment_model/payment_intent_input_model.dart';
import '../models/payment_model/payment_intent_model/ephemeral_key_model/ephermeraLkey_model.dart';
import '../models/payment_model/payment_intent_model/payment_intent_model.dart';
import 'api_keys.dart';
import 'api_services.dart';

class StripeServices {
  ApiServices _apiServies = ApiServices();

  Future<PaymentIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    var response = await _apiServies.post(
      url: 'https://api.stripe.com/v1/payment_intents',
      data: paymentIntentInputModel.toJson(),
      token: APIKeys.secertKey,
    );
    var paymnetIntentModel = PaymentIntentModel.fromJson(response.data);
    return paymnetIntentModel;
  }

  Future initpaymentsheet({required Initpaymentsheetinputmodel initpaymentsheetinputModel}) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customerEphemeralKeySecret:initpaymentsheetinputModel.ephemeralKeySecret,
          paymentIntentClientSecret: initpaymentsheetinputModel.clientSecret,
          customerId: initpaymentsheetinputModel.customerId,
          merchantDisplayName: 'Osama',
        ));
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);
    var ephemeralkey = await createEphemeralkey(customerId: paymentIntentInputModel.customerId);
    var initpaymentsheetinputModel = Initpaymentsheetinputmodel(clientSecret:paymentIntentModel.clientSecret!, ephemeralKeySecret: ephemeralkey.secret!, customerId: paymentIntentInputModel.customerId);

    await initpaymentsheet(
        initpaymentsheetinputModel: initpaymentsheetinputModel);
    await displayPaymentSheet();
  }


  Future<EphemeralKeyModel> createEphemeralkey({required String customerId}) async {
    var response = await _apiServies.post(
      url: 'https://api.stripe.com/v1/ephemeral_keys',
      data: {"customer":customerId},
      headers: {
        'Stripe-Version': '2023-08-16',
        'Content-Type': Headers.formUrlEncodedContentType,
        'Authorization': 'Bearer ${APIKeys.secertKey}'
      },
      token: APIKeys.secertKey,
    );
    var ephemeralKey = EphemeralKeyModel.fromJson(response.data);
    return ephemeralKey;
  }
}
