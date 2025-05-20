import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../../data/models/credit_card.dart';
import '../controller/profile_bloc.dart';
import '../controller/profile_event.dart';
import '../controller/profile_state.dart';
import 'card_formatters.dart';

class AddCardWidget extends StatefulWidget {
  final Function()? onCardAdded;
  final Function(CreditCard)? onCardCreated;
  final bool showTitle;

  const AddCardWidget({
    Key? key,
    this.onCardAdded,
    this.onCardCreated,
    this.showTitle = true,
  }) : super(key: key);

  @override
  State<AddCardWidget> createState() => _AddCardWidgetState();
}

class _AddCardWidgetState extends State<AddCardWidget> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _saveAsDefault = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _nameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<ProfileBloc>(),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is PaymentMethodAdded) {
            if (widget.onCardAdded != null) {
              widget.onCardAdded!();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment method added successfully'),
              ),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showTitle) ...[
                const Text(
                  'Add New Card',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
              ],

              // Card form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Card number field
                    TextFormField(
                      controller: _cardNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Card number',
                        hintText: '1234 5678 9012 3456',
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardNumberInputFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card number';
                        }
                        final cleanValue = value.replaceAll(' ', '');
                        if (cleanValue.length < 16) {
                          return 'Please enter a valid card number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Cardholder name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name on card',
                        hintText: 'JOHN DOE',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter cardholder name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Row for expiry and CVV
                    Row(
                      children: [
                        // Expiry date field
                        Expanded(
                          child: TextFormField(
                            controller: _expiryController,
                            decoration: const InputDecoration(
                              labelText: 'Expiry date',
                              hintText: 'MM/YY',
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
                              if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                                return 'Invalid format';
                              }
                              // Check expiration
                              final parts = value.split('/');
                              final month = int.tryParse(parts[0]);
                              final year = int.tryParse('20${parts[1]}');

                              if (month == null ||
                                  year == null ||
                                  month < 1 ||
                                  month > 12) {
                                return 'Invalid date';
                              }

                              final now = DateTime.now();
                              final expiryDate = DateTime(year, month);

                              if (expiryDate.isBefore(now)) {
                                return 'Card expired';
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // CVV field
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                              hintText: '123',
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
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

                    // Set as default checkbox
                    CheckboxListTile(
                      title: const Text('Set as default payment method'),
                      value: _saveAsDefault,
                      onChanged: (value) {
                        setState(() {
                          _saveAsDefault = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    const SizedBox(height: 16),

                    // Save button
                    if (state is! ProfileLoading)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveCard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Save card',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    else
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _saveCard() {
    if (_formKey.currentState?.validate() ?? false) {
      final card = CreditCard(
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        expiryDate: _expiryController.text,
        cvv: _cvvController.text,
        cardHolderName: _nameController.text,
        isDefault: _saveAsDefault,
      );

      // If onCardCreated callback is provided, call it instead of saving to storage
      if (widget.onCardCreated != null) {
        widget.onCardCreated!(card);
      } else {
        context.read<ProfileBloc>().add(AddPaymentMethod(card));
      }
    }
  }
}
