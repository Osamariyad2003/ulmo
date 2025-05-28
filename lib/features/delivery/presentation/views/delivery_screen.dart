import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:ulmo/core/di/di.dart';
import 'package:ulmo/core/helpers/api_keys.dart';
import 'package:ulmo/core/utils/widgets/custom_button.dart';
import 'package:ulmo/features/bag/presentation/controller/bag_bloc.dart';
import 'package:ulmo/features/bag/presentation/controller/bag_event.dart';
import 'package:ulmo/features/bag/presentation/controller/bag_state.dart';
import 'package:ulmo/features/delivery/presentation/views/address_list_screen.dart'
    show AddressListScreen;
import '../../data/model/delivery_model.dart';

import '../controller/delivery_bloc.dart';
import '../controller/delivery_event.dart';
import '../controller/delivery_state.dart';

class AddressAutocompletePage extends StatefulWidget {
  final String apiKey;
  final Function(String description, double lat, double lng) onAddressSelected;

  AddressAutocompletePage({
    required this.apiKey,
    required this.onAddressSelected,
  });

  @override
  State<AddressAutocompletePage> createState() =>
      AddressAutocompletePageState();
}

class AddressAutocompletePageState extends State<AddressAutocompletePage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Automatically focus the text field when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select delivery address'),
        actions: [
          // Add a close button in case the user wants to cancel
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GooglePlaceAutoCompleteTextField(
              textEditingController: _controller,
              googleAPIKey: widget.apiKey,
              focusNode: _focusNode, // Use the focus node to auto-focus
              debounceTime: 600,
              isLatLngRequired: true,
              countries: ['JO'],
              getPlaceDetailWithLatLng: (Prediction p) {
                widget.onAddressSelected(
                  p.description ?? '',
                  double.tryParse(p.lat ?? '0') ?? 0,
                  double.tryParse(p.lng ?? '0') ?? 0,
                );
                Navigator.pop(context);
              },
              itemClick: (Prediction p) {
                _controller.text = p.description ?? '';
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _controller.text.length),
                );
              },
              inputDecoration: InputDecoration(
                labelText: 'Search address',
                hintText: 'Start typing to search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _controller.clear(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter your full address for delivery',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<DeliveryBloc>(), // Use your DI to get the bloc
      child: BlocConsumer<DeliveryBloc, DeliveryState>(
        listener: (context, state) {
          if (state is DeliveryError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final deliveryBloc = context.read<DeliveryBloc>();
          final deliveryInfo = deliveryBloc.currentDelivery;

          return Scaffold(
            appBar: AppBar(
              title: Text('Delivery Information'),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body:
                state is DeliveryLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildDeliveryForm(context, deliveryInfo),
          );
        },
      ),
    );
  }

  Widget _buildDeliveryForm(BuildContext context, DeliveryInfo? deliveryInfo) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddressSection(context, deliveryInfo),
          const SizedBox(height: 24),
          _buildMethodSection(context, deliveryInfo),
          const SizedBox(height: 24),
          _buildScheduleSection(context, deliveryInfo),
          const Spacer(),
          _buildOrderSummary(context, deliveryInfo),
        ],
      ),
    );
  }

  Widget _buildAddressSection(
    BuildContext context,
    DeliveryInfo? deliveryInfo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Address',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        deliveryInfo?.address != null
            ? AddressCard(
              address: deliveryInfo!.address,
              onTapChange: () => _showAddressPicker(context),
            )
            : ElevatedButton(
              onPressed: () => _showAddressPicker(context),
              child: const Text('Select Address'),
            ),
      ],
    );
  }

  Widget _buildMethodSection(BuildContext context, DeliveryInfo? deliveryInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        DeliveryMethodSelector(
          selectedMethod: deliveryInfo?.method,
          onMethodSelected: (method) {
            context.read<DeliveryBloc>().add(SetDeliveryMethod(method));
          },
        ),
      ],
    );
  }

  Widget _buildScheduleSection(
    BuildContext context,
    DeliveryInfo? deliveryInfo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Schedule',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildDatePicker(context, deliveryInfo?.date),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildTimePicker(context, deliveryInfo?.time),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context, DeliveryInfo? deliveryInfo) {
    return BlocBuilder<BagBloc, BagState>(
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                onPressed:
                    () => _handleContinueToPayment(context, deliveryInfo),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _handleContinueToPayment(
    BuildContext context,
    DeliveryInfo? deliveryInfo,
  ) {
    if (deliveryInfo == null || !_validateDeliveryInfo(context, deliveryInfo)) {
      return;
    }

    try {
      context.read<BagBloc>().add(SelectPaymentMethodEvent('card'));
      Navigator.pushNamed(context, '/payment');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error proceeding to payment: ${e.toString()}')),
      );
    }
  }

  void _showAddressPicker(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => AddressListScreen()));
  }

  Widget _buildDatePicker(BuildContext context, DateTime? date) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          date != null
              ? '${date.day}/${date.month}/${date.year}'
              : 'Select Date',
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, TimeOfDay? time) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(time != null ? _formatTimeOfDay(time) : 'Select Time'),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final deliveryState = context.read<DeliveryBloc>().state;

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (date != null && context.mounted) {
      context.read<DeliveryBloc>().add(
        SetDeliverySchedule(
          date,
          deliveryState is DeliverySelected
              ? deliveryState.time ?? TimeOfDay.now()
              : TimeOfDay.now(),
        ),
      );
    }
  }

  void _selectTime(BuildContext context) async {
    final deliveryState = context.read<DeliveryBloc>().state;
    if (deliveryState is! DeliverySelected) return;

    final time = await showTimePicker(
      context: context,
      initialTime: deliveryState.time ?? TimeOfDay.now(),
    );

    if (time != null && context.mounted) {
      context.read<DeliveryBloc>().add(
        SetDeliverySchedule(deliveryState.date ?? DateTime.now(), time),
      );
    }
  }

  bool _validateDeliveryInfo(BuildContext context, DeliveryInfo deliveryInfo) {
    if (deliveryInfo.address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return false;
    }
    if (deliveryInfo.method.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery method')),
      );
      return false;
    }
    if (deliveryInfo.date == null || deliveryInfo.time == null) {
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
