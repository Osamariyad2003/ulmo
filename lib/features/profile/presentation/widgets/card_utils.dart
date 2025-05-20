import 'package:flutter/material.dart';

class CardUtils {
  // Card types and their regex patterns
  static Map<CardType, RegExp> cardTypePatterns = {
    CardType.visa: RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$'),
    CardType.mastercard: RegExp(r'^(5[1-5]|2[2-7])[0-9]{14}$'),
    CardType.amex: RegExp(r'^3[47][0-9]{13}$'),
    CardType.discover: RegExp(r'^6(?:011|5[0-9]{2})[0-9]{12}$'),
    CardType.diners: RegExp(r'^3(?:0[0-5]|[68][0-9])[0-9]{11}$'),
    CardType.jcb: RegExp(r'^(?:2131|1800|35\d{3})\d{11}$'),
  };

  // Get card type from card number
  static CardType getCardTypeFrmNumber(String cardNumber) {
    cardNumber = getCleanedNumber(cardNumber);

    if (cardNumber.isEmpty) {
      return CardType.unknown;
    }

    for (var cardType in cardTypePatterns.keys) {
      if (cardTypePatterns[cardType]!.hasMatch(cardNumber)) {
        return cardType;
      }
    }

    return CardType.unknown;
  }

  // Get cleaned card number (remove all non-digit characters)
  static String getCleanedNumber(String cardNumber) {
    return cardNumber.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Format card number for display
  static String formatCardNumber(String cardNumber) {
    if (cardNumber.isEmpty) return '';

    // Clean the number
    cardNumber = getCleanedNumber(cardNumber);

    CardType cardType = getCardTypeFrmNumber(cardNumber);

    // Format based on card type
    switch (cardType) {
      case CardType.visa:
      case CardType.mastercard:
      case CardType.discover:
      case CardType.jcb:
        return _formatWithPattern(cardNumber, [4, 4, 4, 4]);
      case CardType.amex:
        return _formatWithPattern(cardNumber, [4, 6, 5]);
      case CardType.diners:
        return _formatWithPattern(cardNumber, [4, 6, 4]);
      case CardType.unknown:
      default:
        // If we don't know the type, format in groups of 4
        return _formatWithPattern(cardNumber, [4, 4, 4, 4]);
    }
  }

  // Format with a specific pattern
  static String _formatWithPattern(String cardNumber, List<int> pattern) {
    var result = '';
    var currentIndex = 0;

    for (var i = 0; i < pattern.length; i++) {
      var currentPart = cardNumber.substring(
        currentIndex,
        currentIndex + pattern[i] > cardNumber.length
            ? cardNumber.length
            : currentIndex + pattern[i],
      );

      if (currentPart.isNotEmpty) {
        result += currentPart;
        if (i < pattern.length - 1 &&
            currentIndex + pattern[i] < cardNumber.length) {
          result += ' ';
        }
      }

      currentIndex += pattern[i];
    }

    return result;
  }

  // Validate card number using Luhn algorithm
  static bool validateCardNumber(String cardNumber) {
    cardNumber = getCleanedNumber(cardNumber);

    if (cardNumber.isEmpty) return false;

    // Apply Luhn algorithm
    int sum = 0;
    bool alternate = false;
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  // Validate expiry date (MM/YY format)
  static bool validateExpiryDate(String month, String year) {
    if (month.isEmpty || year.isEmpty) return false;

    // Convert to numbers
    int monthNum = int.tryParse(month) ?? 0;
    int yearNum = int.tryParse(year) ?? 0;

    // Check if month is between 1-12
    if (monthNum < 1 || monthNum > 12) return false;

    // Get current date
    DateTime now = DateTime.now();
    int currentYear = now.year % 100; // Last two digits of year
    int currentMonth = now.month;

    // Compare with current date
    return (yearNum > currentYear) ||
        (yearNum == currentYear && monthNum >= currentMonth);
  }

  // Validate CVV (usually 3 or 4 digits)
  static bool validateCVV(String cvv, CardType cardType) {
    if (cvv.isEmpty) return false;

    // Most cards use 3 digit CVV, Amex uses 4 digits
    int expectedLength = (cardType == CardType.amex) ? 4 : 3;

    return cvv.length == expectedLength && cvv.contains(RegExp(r'^[0-9]+$'));
  }

  // Get card icon based on card type
  static IconData getCardIcon(CardType cardType) {
    switch (cardType) {
      case CardType.visa:
        return Icons.credit_card; // Replace with actual Visa icon
      case CardType.mastercard:
        return Icons.credit_card; // Replace with actual Mastercard icon
      case CardType.amex:
        return Icons.credit_card; // Replace with actual Amex icon
      case CardType.discover:
        return Icons.credit_card; // Replace with actual Discover icon
      case CardType.diners:
        return Icons.credit_card; // Replace with actual Diners icon
      case CardType.jcb:
        return Icons.credit_card; // Replace with actual JCB icon
      case CardType.unknown:
      default:
        return Icons.credit_card;
    }
  }

  // Get card color based on card type
  static Color getCardColor(CardType cardType) {
    switch (cardType) {
      case CardType.visa:
        return Colors.blue;
      case CardType.mastercard:
        return Colors.orangeAccent;
      case CardType.amex:
        return Colors.blueAccent;
      case CardType.discover:
        return Colors.orange;
      case CardType.diners:
        return Colors.blueGrey;
      case CardType.jcb:
        return Colors.green;
      case CardType.unknown:
      default:
        return Colors.grey;
    }
  }
}

// Enum for card types
enum CardType { visa, mastercard, amex, discover, diners, jcb, unknown }
