import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ulmo/core/themes/colors_style.dart';
import 'package:ulmo/features/profile/presentation/widgets/card_utils.dart';
import '../../data/models/credit_card.dart';

class AddCardBottomSheet extends StatefulWidget {
  final Function(CreditCard card) onCardAdded;

  const AddCardBottomSheet({Key? key, required this.onCardAdded})
    : super(key: key);

  @override
  State<AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<AddCardBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _holderNameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  String _cardType = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _holderNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _updateCardType(String cardNumber) {
    final type = CardUtils.getCardTypeFrmNumber(cardNumber.replaceAll(' ', ''));
    setState(() {
      _cardType = type as String;
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Create a new card object
      final card = CreditCard(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        cardHolderName: _holderNameController.text,
        expiryDate: _expiryDateController.text,
        cvv: _cvvController.text,
        cardType: _cardType,
        isDefault: false,
      );

      // Add delay to simulate network request
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onCardAdded(card);
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Payment Card',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Card Number
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter(),
                ],
                onChanged: _updateCardType,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your card number';
                  }
                  if (!CardUtils.validateCardNumber(
                    value.replaceAll(' ', ''),
                  )) {
                    return 'Invalid card number';
                  }
                  return null;
                },
              ),
              if (_cardType.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Card type: $_cardType',
                    style: TextStyle(
                      color: AppColors.accentYellow,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Cardholder Name
              TextFormField(
                controller: _holderNameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cardholder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Expiry Date and CVV
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      decoration:  InputDecoration(
                        labelText: 'MM/YY',
                        hintText: 'MM/YY',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        ExpiryDateInputFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (!CardUtils.validateCardNumber(value)) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                          4,
                        ), // AMEX has 4 digits
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (value.length < 3) {
                          return 'Invalid CVV';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text('SAVE CARD'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String text = newValue.text.replaceAll(' ', '');
    String formatted = '';

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String text = newValue.text;
    if (text.length > 2 && !text.contains('/')) {
      text = text.substring(0, 2) + '/' + text.substring(2);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
