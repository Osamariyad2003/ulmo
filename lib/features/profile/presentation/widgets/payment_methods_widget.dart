import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../../data/models/credit_card.dart';
import '../controller/profile_bloc.dart';
import '../controller/profile_event.dart';
import '../controller/profile_state.dart';
import 'add_card_screen.dart';

class PaymentMethodsWidget extends StatelessWidget {
  final bool showTitle;
  final bool showAddButton;
  final Function(CreditCard)? onCardSelected;

  const PaymentMethodsWidget({
    Key? key,
    this.showTitle = true,
    this.showAddButton = true,
    this.onCardSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Payment methods',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        create: (context) => di<ProfileBloc>()..add(LoadPaymentMethods()),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is PaymentMethodsLoaded)
                    Expanded(
                      child: PaymentMethodsList(
                        cards: state.cards,
                        defaultCardId: state.defaultCardId,
                        onCardSelected: onCardSelected,
                      ),
                    )
                  else if (state is ProfileLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    const Expanded(
                      child: Center(
                        child: Text('Error loading payment methods'),
                      ),
                    ),

                  // Add new payment method button
                  if (showAddButton)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddCardScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Add new payment method',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PaymentMethodsList extends StatelessWidget {
  final List<CreditCard> cards;
  final String? defaultCardId;
  final Function(CreditCard)? onCardSelected;

  const PaymentMethodsList({
    Key? key,
    required this.cards,
    this.defaultCardId,
    this.onCardSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const Center(
        child: Text(
          'No payment methods added yet',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return PaymentMethodItem(
          card: card,
          isDefault: card.id == defaultCardId,
          onCardSelected: onCardSelected,
        );
      },
    );
  }
}

class PaymentMethodItem extends StatelessWidget {
  final CreditCard card;
  final bool isDefault;
  final Function(CreditCard)? onCardSelected;

  const PaymentMethodItem({
    Key? key,
    required this.card,
    this.isDefault = false,
    this.onCardSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get last 4 digits of card number
    final lastFourDigits =
        card.cardNumber.length >= 4
            ? card.cardNumber.substring(card.cardNumber.length - 4)
            : card.cardNumber;

    // Get card type name (Visa, Mastercard, etc)
    final cardTypeName = _getCardTypeName(card.cardType ?? "");

    return GestureDetector(
      onTap: onCardSelected != null ? () => onCardSelected!(card) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            // Card logo
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getCardColor(card.cardType ?? "Visa"),
                shape: BoxShape.circle,
              ),
              child: Center(child: _getCardLogo(card.cardType ?? "Visa")),
            ),
            const SizedBox(width: 16),
            // Card details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$cardTypeName $lastFourDigits',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card.expiryDate,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Options menu
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
              onPressed: () => _showCardOptions(context, card),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCardLogo(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return const Text(
          'V',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
      case 'mastercard':
        return const Text(
          'M',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
      case 'amex':
        return const Text(
          'A',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
      default:
        return const Icon(Icons.credit_card, color: Colors.white, size: 20);
    }
  }

  Color _getCardColor(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return Colors.blue;
      case 'mastercard':
        return Colors.orange;
      case 'amex':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getCardTypeName(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return 'Visa';
      case 'mastercard':
        return 'Mastercard';
      case 'amex':
        return 'American Express';
      default:
        return 'Card';
    }
  }

  void _showCardOptions(BuildContext context, CreditCard card) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Set as default'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProfileBloc>().add(
                    SetDefaultPaymentMethod(card.id!),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Delete card',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, card);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, CreditCard card) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Card'),
            content: Text(
              'Are you sure you want to remove this card (${card.cardType})?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  context.read<ProfileBloc>().add(
                    DeletePaymentMethod(card.id!),
                  );
                },
                child: const Text('DELETE'),
              ),
            ],
          ),
    );
  }
}
