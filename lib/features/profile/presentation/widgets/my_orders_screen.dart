import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../../presentation/controller/profile_bloc.dart';
import '../../presentation/controller/profile_event.dart';
import '../../presentation/controller/profile_state.dart';
import '../widgets/profile_header.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load orders when screen opens
    context.read<ProfileBloc>().add(LoadOrders());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<ProfileBloc>()..add(LoadOrders()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Header with back button
                    const ProfileHeader(
                      title: 'My orders',
                      showBackButton: true,
                    ),

                    const SizedBox(height: 24),

                    // Search bar
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey[500],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Sort and Filter row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _showSortOptions(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sort',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.grey[800],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[800],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _showFilterOptions(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.grey[800],
                                  ),
                                ),
                                Icon(
                                  Icons.filter_list,
                                  color: Colors.grey[800],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Orders list
                    Expanded(child: _buildOrdersList(state)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(ProfileState state) {
    if (state is ProfileLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProfileError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Error loading orders',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey[800],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileBloc>().add(LoadOrders());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    } else if (state is ProfileOrdersLoaded) {
      if (state.orders.isEmpty) {
        return Center(
          child: Text(
            'No orders found',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey[800],
              fontSize: 16,
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: state.orders.length,
        itemBuilder: (context, index) {
          final order = state.orders[index];
          return _buildOrderItem(order);
        },
      );
    }

    // Default placeholder
    return const SizedBox();
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    // Extract order data
    final String orderId = order['id'] ?? '';
    final String date = order['date'] ?? '';
    final String status = order['status'] ?? 'Processing';
    final double total = (order['total'] as num?)?.toDouble() ?? 0.0;
    final List<dynamic> items = order['items'] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header with date and total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Order status and ID
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '#$orderId',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Order product images
          SizedBox(
            height: 72,
            child: Row(
              children: [
                for (int i = 0; i < items.length && i < 3; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildProductThumbnail(items[i]),
                  ),
                if (items.length > 3)
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '+${items.length - 3}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _buildProductThumbnail(Map<String, dynamic> product) {
    final String imageUrl = product['imageUrl'] ?? '';

    return Container(
      width: 72,
      height: 72,
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
              ? Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey[400],
                ),
              )
              : null,
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

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort by',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _sortOption('Date (newest first)'),
              _sortOption('Date (oldest first)'),
              _sortOption('Total (high to low)'),
              _sortOption('Total (low to high)'),
            ],
          ),
        );
      },
    );
  }

  Widget _sortOption(String title) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        // Implement sort functionality here
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter orders',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Reset filters
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey[300]),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _filterCheckbox('All'),
                      _filterCheckbox('Processing'),
                      _filterCheckbox('Shipped'),
                      _filterCheckbox('Delivered'),
                      _filterCheckbox('Cancelled'),

                      const SizedBox(height: 16),
                      const Text(
                        'Time period',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _filterCheckbox('Last 30 days'),
                      _filterCheckbox('Last 6 months'),
                      _filterCheckbox('Last year'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Apply filters
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontFamily: 'Poppins',
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
        );
      },
    );
  }

  Widget _filterCheckbox(String title) {
    // In a real app, you would use state to track which filters are selected
    return StatefulBuilder(
      builder: (context, setState) {
        bool isChecked = false;
        return InkWell(
          onTap: () {
            setState(() {
              isChecked = !isChecked;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    activeColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
