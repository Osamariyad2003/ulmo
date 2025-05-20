import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class CreditCard {
  @HiveField(0)
  final String cardNumber;

  @HiveField(1)
  final String expiryDate;

  @HiveField(2)
  final String cvv;

  @HiveField(3)
  final String cardHolderName;

  @HiveField(4)
  final String? id;

  @HiveField(5)
  final String? cardType;

  @HiveField(6)
  final bool isDefault;

  CreditCard({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardHolderName,
    this.id,
    String? cardType,
    this.isDefault = false,
  }) : cardType = cardType ?? _detectedCardType(cardNumber);

  // Static function to detect card type
  static String _detectedCardType(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanNumber.isEmpty) return 'unknown';
    if (RegExp(r'^4').hasMatch(cleanNumber)) return 'visa';
    if (RegExp(r'^5[1-5]').hasMatch(cleanNumber) ||
        RegExp(
          r'^(222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720)',
        ).hasMatch(cleanNumber)) {
      return 'mastercard';
    }
    if (RegExp(r'^3[47]').hasMatch(cleanNumber)) return 'amex';
    if (RegExp(
      r'^(6011|65|64[4-9]|622(12[6-9]|1[3-9]|[2-8]|9[01]|92[0-5]))',
    ).hasMatch(cleanNumber)) {
      return 'discover';
    }
    return 'unknown';
  }

  CreditCard copiedWith({
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? cardHolderName,
    String? id,
    String? cardType,
    bool? isDefault,
  }) {
    return CreditCard(
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      id: id ?? this.id,
      cardType: cardType ?? this.cardType,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  // Create from JSON data
  factory CreditCard.fromLoadedJson(Map<String, dynamic> json) {
    return CreditCard(
      cardNumber: json['cardNumber'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      cvv: json['cvv'] ?? '',
      cardHolderName: json['cardHolderName'] ?? '',
      id: json['id'],
      cardType: json['cardType'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  // Create from Stripe data
  factory CreditCard.fromLoadedStripe(Map<String, dynamic> stripeData) {
    final card = stripeData['card'] ?? {};
    final billingDetails = stripeData['billing_details'] ?? {};
    final expMonth = card['exp_month']?.toString().padLeft(2, '0') ?? '';
    final expYear = card['exp_year']?.toString().substring(2) ?? '';

    return CreditCard(
      cardNumber: card['last4'] != null ? '****${card['last4']}' : '',
      expiryDate: '$expMonth/$expYear',
      cvv: '',
      cardHolderName: billingDetails['name'] ?? '',
      id: stripeData['id'],
      cardType: card['brand'],
      isDefault: false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> convertedToJson() {
    return {
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardHolderName': cardHolderName,
      'id': id,
      'cardType': cardType,
      'isDefault': isDefault,
    };
  }

  // Convert to Stripe format
  Map<String, dynamic> convertedToStripeJson() {
    final parts = expiryDate.split('/');
    String expMonth = parts.isNotEmpty ? parts[0] : '';
    String expYear = parts.length > 1 ? '20${parts[1]}' : '';

    return {
      'card[number]': cardNumber.replaceAll(RegExp(r'\s'), ''),
      'card[exp_month]': expMonth,
      'card[exp_year]': expYear,
      'card[cvc]': cvv,
    };
  }

  // Get masked card number for display
  String get maskedNumber {
    if (cardNumber.length < 4) return cardNumber;
    if (cardNumber.startsWith('****'))
      return '•••• •••• •••• ${cardNumber.substring(4)}';
    return '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';
  }

  // Get display name for UI
  String get displayedName {
    final last4 =
        cardNumber.length >= 4
            ? cardNumber.substring(cardNumber.length - 4)
            : cardNumber;

    final type =
        cardType?.isNotEmpty == true
            ? '${cardType![0].toUpperCase()}${cardType!.substring(1)}'
            : 'Card';

    return '$type •••• $last4';
  }

  // Get card icon asset path
  String get cardIconPath {
    switch (cardType?.toLowerCase()) {
      case 'visa':
        return 'assets/images/visa.png';
      case 'mastercard':
        return 'assets/images/mastercard.png';
      case 'amex':
        return 'assets/images/amex.png';
      case 'discover':
        return 'assets/images/discover.png';
      default:
        return 'assets/images/credit_card.png';
    }
  }

  // Get expiry month
  String get extractedMonth {
    final parts = expiryDate.split('/');
    return parts.isNotEmpty ? parts[0] : '';
  }

  // Get expiry year
  String get extractedYear {
    final parts = expiryDate.split('/');
    return parts.length > 1 ? '20${parts[1]}' : '';
  }

  // Check if card is expired
  bool get wasExpired {
    try {
      final parts = expiryDate.split('/');
      if (parts.length != 2) return true;

      final month = int.tryParse(parts[0]);
      final year = int.tryParse('20${parts[1]}');
      if (month == null || year == null) return true;

      final now = DateTime.now();
      final expiryDateTime = DateTime(
        year,
        month + 1,
        0,
      ); // renamed from expiryDate to expiryDateTime
      return expiryDateTime.isBefore(now);
    } catch (e) {
      return true;
    }
  }
}
