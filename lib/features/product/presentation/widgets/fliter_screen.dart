import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/features/product/presentation/widgets/category_filtered_screen.dart';
import 'package:ulmo/features/product/presentation/widgets/filter_row.dart';

import '../../../../core/di/di.dart';
import '../../data/models/filter_model.dart';
import '../controller/product_bloc.dart';
import '../controller/product_event.dart';
import '../controller/product_state.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double _minPrice = 0;
  double _maxPrice = 700;

  // Example defaults for demonstration
  String _category = 'furniture';
  String _productType = 'All';
  String _color = 'All';
  String _size = 'All';
  String _quality = 'All';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<ProductBloc>(),
      child: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductFilterLoaded ) {
            // If you want to pop back or do something after filtering:
            // Navigator.pop(context);
          } else if (state is ProductFilterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          final isLoading = (state is ProductFilterLoading);

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Filter'),
              actions: [
                TextButton(
                  onPressed: _onClearFilters,
                  child: const Text('Clear'),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                   SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${_minPrice.round()}'),
                      Text('\$${_maxPrice.round()}'),
                    ],
                  ),
                  RangeSlider(
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    values: RangeValues(_minPrice, _maxPrice),
                    onChanged: (vals) {
                      setState(() {
                        _minPrice = vals.start;
                        _maxPrice = vals.end;
                      });
                    },
                  ),
                  Divider(),
                  InkWell(
                    onTap:(){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> CategoryFilterScreen()));
                    } ,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Category',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Text(
                            _category.isEmpty ? 'All' : _category,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 14),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  FilterRowWidget(label: 'Category', selectedValue: '', options: ['','All','None'], onChanged: (value){}),


                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onShowItems,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text('Show 25 items'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  void _onSelectCategory() {
    // Example: Open a category selection screen or show a dialog
    // For now, just toggle "furniture"/"All"
    setState(() {
      _category = (_category == 'furniture') ? '' : 'furniture';
    });
  }

  // The next few methods are placeholders for picking productType, color, size, quality
  // You could open sub-screens or show a bottom sheet, etc.
  void _onSelectProductType() {
    setState(() {
      _productType = (_productType == 'All') ? 'Chair' : 'All';
    });
  }

  void _onSelectColor() {
    setState(() {
      _color = (_color == 'All') ? 'Blue' : 'All';
    });
  }

  void _onSelectSize() {
    setState(() {
      _size = (_size == 'All') ? 'Large' : 'All';
    });
  }

  void _onSelectQuality() {
    setState(() {
      _quality = (_quality == 'All') ? 'High' : 'All';
    });
  }

  void _onClearFilters() {
    setState(() {
      _minPrice = 0;
      _maxPrice = 700;
      _category = 'furniture';
      _productType = 'All';
      _color = 'All';
      _size = 'All';
      _quality = 'All';
    });
  }

  void _onShowItems() {
    final filter = FilterOptions(
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      categoryId: _category.isEmpty ? null : _category,
    );
    context.read<ProductBloc>().add(LoadFilteredProductsEvent(filter));
  }
}

