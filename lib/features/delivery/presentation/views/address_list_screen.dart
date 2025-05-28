import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/features/delivery/presentation/widgets/address_form_screen.dart';
import '../widgets/address_item.dart';
import '../widgets/add_address_button.dart';
import '../controller/delivery_bloc.dart';
import '../controller/delivery_event.dart';
import '../controller/delivery_state.dart';
import '../../data/model/delivery_model.dart';
import '../views/delivery_screen.dart';
import 'package:ulmo/core/di/di.dart';
import 'package:ulmo/core/local/caches_keys.dart'; // Import CacheKeys

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fix the provider issue by using proper initialization
    return BlocProvider<DeliveryBloc>(
      create: (context) {
        final bloc = di<DeliveryBloc>();
        final userId = CacheKeys.cachedUserId; // Use cached userId
        bloc.add(LoadSavedAddresses(userId));
        return bloc;
      },
      child: const AddressListContent(),
    );
  }
}

class AddressListContent extends StatelessWidget {
  const AddressListContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Address book',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<DeliveryBloc, DeliveryState>(
        builder: (context, state) {
          if (state is DeliveryLoading) {
            return const LoadingAddressView();
          } else if (state is DeliveryError) {
            return ErrorAddressView(message: state.message);
          } else if (state is SavedAddressesLoaded) {
            return AddressListView(addresses: state.addresses);
          } else {
            return const EmptyAddressView();
          }
        },
      ),
    );
  }
}

class LoadingAddressView extends StatelessWidget {
  const LoadingAddressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading addresses...'),
        ],
      ),
    );
  }
}

class ErrorAddressView extends StatelessWidget {
  final String message;

  const ErrorAddressView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Fixed: Use a static userId or get from auth
                const userId = ""; // Replace with actual userId
                context.read<DeliveryBloc>().add(LoadSavedAddresses(userId));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyAddressView extends StatelessWidget {
  const EmptyAddressView({Key? key}) : super(key: key); // Added const

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'No addresses found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
          AddAddressButton(onTap: () => _navigateToDeliveryScreen(context)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class AddressListView extends StatelessWidget {
  final List<DeliveryInfo> addresses;

  const AddressListView({Key? key, required this.addresses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (addresses.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                'No saved addresses yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: addresses.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return AddressItem(
                    address: address.address,
                    name: address.userId,
                    phone: '',
                    onTap: () => _selectAddress(context, address),
                  );
                },
              ),
            ),
          const Spacer(),
          AddAddressButton(onTap: () => _navigateToDeliveryScreen(context)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Functions moved outside of classes and made private
void _selectAddress(BuildContext context, DeliveryInfo address) {
  context.read<DeliveryBloc>().add(SelectSavedAddress(address));
  Navigator.pop(context);
}

// Fix the BlocProvider.of error by capturing the bloc before navigation
void _navigateToDeliveryScreen(BuildContext context) {
  // Capture the bloc instance before creating the route
  final deliveryBloc = context.read<DeliveryBloc>();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (context) => BlocProvider.value(
            // Use the captured bloc instead of trying to read from the new context
            value: deliveryBloc,
            child: AddressFormScreen(),
          ),
    ),
  );
}
