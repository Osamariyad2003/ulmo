import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../../presentation/controller/profile_bloc.dart';
import '../../presentation/controller/profile_event.dart';
import '../../presentation/controller/profile_state.dart';
import '../widgets/profile_header.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create:
              (context) =>
                  di<ProfileBloc>()..add(LoadOrderDetails(widget.orderId)),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return _buildLoadingState();
              } else if (state is ProfileError) {
                return _buildErrorState(state.message, context);
              } else if (state is OrderDetailsLoaded) {
                return _buildOrderDetails(state.orderDetails, context);
              }
              return _buildLoadingState();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileHeader(title: 'Order', showBackButton: true),
          const SizedBox(height: 32),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error loading order',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProfileBloc>().add(
                      LoadOrderDetails(widget.orderId),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(
    Map<String, dynamic> orderDetails,
    BuildContext context,
  ) {
    final String orderId = orderDetails['id'] ?? '';
    final String date = orderDetails['date'] ?? '';
    final String status = orderDetails['status'] ?? '';
    final List<dynamic> items = orderDetails['items'] ?? [];
    final Map<String, dynamic> delivery = orderDetails['delivery'] ?? {};

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button and order number
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Text(
                  'Order #$orderId',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Date and time
            Row(
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _getStatusColor(status),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Order items
            ...items.map((item) => _buildOrderItem(item)).toList(),

            const SizedBox(height: 32),

            // Delivery info section
            const Text(
              'delivery info',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // Delivery method
            Row(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  size: 20,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 12),
                Text(
                  delivery['method'] ?? 'By courier',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Delivery address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    delivery['address'] ?? 'No address provided',
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Order total summary
            _buildOrderSummary(orderDetails),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    final String name = item['name'] ?? '';
    final double price = (item['price'] as num?)?.toDouble() ?? 0.0;
    final String imageUrl = item['imageUrl'] ?? '';
    final Map<String, dynamic> variants = item['variants'] ?? {};

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              image:
                  imageUrl.isNotEmpty
                      ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                imageUrl.isEmpty
                    ? Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey[400],
                    )
                    : null,
          ),

          const SizedBox(width: 16),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                // Product variants if any
                if (variants.isNotEmpty) ...[
                  ...variants.entries.map(
                    (e) => Text(
                      '${e.key}: ${e.value}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Product price
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                // Order again button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add to cart functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Order again',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(Map<String, dynamic> orderDetails) {
    final double subtotal =
        (orderDetails['subtotal'] as num?)?.toDouble() ?? 0.0;
    final double shipping =
        (orderDetails['shipping'] as num?)?.toDouble() ?? 0.0;
    final double discount =
        (orderDetails['discount'] as num?)?.toDouble() ?? 0.0;
    final double tax = (orderDetails['tax'] as num?)?.toDouble() ?? 0.0;
    final double total = (orderDetails['total'] as num?)?.toDouble() ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
        _buildSummaryRow(
          'Shipping',
          shipping > 0 ? '\$${shipping.toStringAsFixed(2)}' : 'Free',
        ),

        if (discount > 0)
          _buildSummaryRow('Discount', '-\$${discount.toStringAsFixed(2)}'),

        if (tax > 0) _buildSummaryRow('Tax', '\$${tax.toStringAsFixed(2)}'),

        const Divider(height: 32),

        _buildSummaryRow(
          'Total',
          '\$${total.toStringAsFixed(2)}',
          isBold: true,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: isBold ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
