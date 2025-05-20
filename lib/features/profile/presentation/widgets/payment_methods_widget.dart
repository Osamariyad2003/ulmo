import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    return BlocProvider(
      create: (context) => di<ProfileBloc>()..add(LoadPaymentMethods()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is PaymentMethodDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment method removed')),
            );
          } else if (state is DefaultPaymentMethodSet) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Default payment method updated')),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showTitle) ...[
                const Text(
                  'Payment Methods',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
              ],

              // Payment methods list
              if (state is PaymentMethodsLoaded)
                _buildPaymentMethodsList(context, state)
              else if (state is ProfileLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text('Error loading payment methods'),
                  ),
                ),

              // Add new payment method button
              if (showAddButton)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddCardScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Add new payment method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaymentMethodsList(
    BuildContext context,
    PaymentMethodsLoaded state,
  ) {
    if (state.cards.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: Text(
            'No payment methods added yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.cards.length,
      itemBuilder: (context, index) {
        final card = state.cards[index];
        final isDefault = card.id == state.defaultCardId;
        return _buildCardItem(context, card, isDefault);
      },
    );
  }

  Widget _buildCardItem(BuildContext context, CreditCard card, bool isDefault) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              _showDeleteConfirmation(context, card);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onCardSelected != null ? () => onCardSelected!(card) : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border:
                isDefault
                    ? Border.all(color: Colors.black, width: 2)
                    : Border.all(color: Colors.grey.shade300),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Image.asset(
              card.cardIconPath,
              width: 40,
              height: 40,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.credit_card, size: 40),
            ),
            title: Text(
              card.cardHolderName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Expires: ${card.expiryDate}'),
                Text(card.cardHolderName),
                if (isDefault)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Default',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            trailing:
                !isDefault
                    ? IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => _showCardOptions(context, card),
                    )
                    : null,
          ),
        ),
      ),
    );
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
