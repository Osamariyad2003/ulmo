import 'package:flutter/services.dart';

/// Formats the credit card number with spaces after every 4 digits
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Check if the user is deleting characters
    if (oldValue.text.length >= newValue.text.length) {
      return newValue;
    }

    var text = newValue.text.replaceAll(' ', '');
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

/// Formats the expiry date as MM/YY
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    // Handle the case when deleting the '/'
    if (oldValue.text.length > newValue.text.length &&
        oldValue.text.contains('/') &&
        !newValue.text.contains('/')) {
      // Remove the last digit before '/'
      text = newValue.text.substring(0, newValue.text.length - 1);
    }

    // Remove all non-digits
    text = text.replaceAll(RegExp(r'\D'), '');

    if (text.length > 4) {
      text = text.substring(0, 4);
    }

    // Format as MM/YY
    if (text.length >= 3) {
      text = text.substring(0, 2) + '/' + text.substring(2);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
