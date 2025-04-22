import 'package:dio/dio.dart';

import '../../../core/helpers/api_services.dart';
import '../../../core/utils/constant.dart';



// class CardDataSource {
//   final BenefitPayFlutter _benefitPay = BenefitPayFlutter();
//
//   Future<String> startBenefitPay({
//     required String amount,
//     required String currency,
//     required String merchantName,
//     required String merchantCategoryCode,
//     required String orderId,
//   }) async {
//     try {
//       final result = await _benefitPay.startBenefitPayment(
//         amount: amount,
//         currencyCode: currency,
//         merchantName: merchantName,
//         merchantCategoryCode: merchantCategoryCode,
//         orderId: orderId,
//       );
//
//       return result; // "success", "failed", or "cancelled"
//     } catch (e) {
//       return 'error: $e';
//     }
//   }
// }

