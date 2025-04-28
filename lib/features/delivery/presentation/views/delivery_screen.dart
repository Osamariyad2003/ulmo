import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:ulmo/core/utils/widgets/custom_button.dart';
import 'package:ulmo/features/bag/presentation/controller/bag_bloc.dart';
import 'package:ulmo/features/bag/presentation/controller/bag_event.dart';
import 'package:ulmo/features/bag/presentation/controller/bag_state.dart';

import '../controller/delivery_bloc.dart';
import '../controller/delivery_event.dart';
import '../controller/delivery_state.dart';

class AddressPickerButton extends StatelessWidget {
  final String apiKey;

  const AddressPickerButton({super.key, required this.apiKey});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Pick address'),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => _AddressAutocompletePage(apiKey: apiKey),
          ),
        );
      },
    );
  }
}

class _AddressAutocompletePage extends StatelessWidget {
  final String apiKey;

  const _AddressAutocompletePage({required this.apiKey});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Select delivery address')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GooglePlaceAutoCompleteTextField(
          textEditingController: controller,
          googleAPIKey: apiKey,
          debounceTime: 600, // ms between keystrokes
          isLatLngRequired: true, // fetch lat/lng in details call
          countries: const ['JO'], // restrict to Jordan (optional)
          getPlaceDetailWithLatLng: (Prediction p) {
            context.read<DeliveryBloc>().add(
              SetDeliveryAddress(
                p.description ?? '',
                double.tryParse(p.lat ?? '0') ?? 0,
                double.tryParse(p.lng ?? '0') ?? 0,
              ),
            );
            Navigator.pop(context);
          },
          itemClick: (Prediction p) {
            // Update the text field UI when the user taps a row.
            controller.text = p.description ?? '';
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
          },
          inputDecoration: const InputDecoration(
            labelText: 'Search address',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Information'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (_) => DeliveryBloc(),
        child: BlocBuilder<DeliveryBloc, DeliveryState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery address section
                  const Text(
                    'Delivery Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Address display or picker
                  state.address != null
                      ? AddressCard(
                        address: state.address!,
                        onTapChange: () => _showAddressPicker(context),
                      )
                      : AddressPickerButton(apiKey: 'YOUR_GOOGLE_MAPS_API_KEY'),

                  const SizedBox(height: 24),

                  // Delivery method section
                  const Text(
                    'Delivery Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Delivery method options
                  DeliveryMethodSelector(
                    selectedMethod: state.method,
                    onMethodSelected: (method) {
                      context.read<DeliveryBloc>().add(
                        SetDeliveryMethod(method),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Delivery schedule section
                  const Text(
                    'Delivery Schedule',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Date and time pickers
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              state.date != null
                                  ? '${state.date!.day}/${state.date!.month}/${state.date!.year}'
                                  : 'Select Date',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => _selectTime(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              state.time != null
                                  ? _formatTimeOfDay(state.time!)
                                  : 'Select Time',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Order summary from bag
                  BlocBuilder<BagBloc, BagState>(
                    builder: (context, bagState) {
                      if (bagState is BagLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${bagState.bag.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              label: 'Continue to Payment',
                              onPressed: () {
                                if (_validateDeliveryInfo(context, state)) {
                                  // Navigate to payment
                                  context.read<BagBloc>().add(
                                    SelectPaymentMethodEvent('card'),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Proceeding to payment'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddressPicker(BuildContext context) {
    // Show address picker dialog
  }

  void _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (date != null && context.mounted) {
      // Get the current time or use a default time
      final currentTime =
          context.read<DeliveryBloc>().state.time ?? TimeOfDay.now();
      context.read<DeliveryBloc>().add(SetDeliverySchedule(date, currentTime));
    }
  }

  void _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null && context.mounted) {
      // Get the current date or use a default date
      final currentDate =
          context.read<DeliveryBloc>().state.date ?? DateTime.now();
      context.read<DeliveryBloc>().add(SetDeliverySchedule(currentDate, time));
    }
  }

  bool _validateDeliveryInfo(BuildContext context, DeliveryState state) {
    if (state.address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return false;
    }

    if (state.method == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery method')),
      );
      return false;
    }

    if (state.date == null || state.time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select delivery date and time')),
      );
      return false;
    }

    return true;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

class AddressCard extends StatelessWidget {
  final String address;
  final VoidCallback onTapChange;

  const AddressCard({
    Key? key,
    required this.address,
    required this.onTapChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(address, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTapChange,
            child: const Text(
              'Change',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryMethodSelector extends StatelessWidget {
  final String? selectedMethod;
  final Function(String) onMethodSelected;

  const DeliveryMethodSelector({
    Key? key,
    this.selectedMethod,
    required this.onMethodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMethodTile(
          context,
          'standard',
          'Standard Delivery',
          '3-5 days',
          'Free',
        ),
        const SizedBox(height: 12),
        _buildMethodTile(
          context,
          'express',
          'Express Delivery',
          '1-2 days',
          '\$9.99',
        ),
      ],
    );
  }

  Widget _buildMethodTile(
    BuildContext context,
    String methodId,
    String title,
    String timeframe,
    String cost,
  ) {
    final isSelected = selectedMethod == methodId;

    return GestureDetector(
      onTap: () => onMethodSelected(methodId),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey,
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? const Center(
                        child: Icon(Icons.check, size: 16, color: Colors.black),
                      )
                      : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    timeframe,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Text(
              cost,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
