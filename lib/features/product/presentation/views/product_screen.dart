import 'package:flutter/material.dart';
import 'package:ulmo/core/themes/colors_style.dart';
import 'package:ulmo/features/categories/presentation/widgets/search_field.dart';
import 'package:ulmo/features/product/domain/usecases/fetch_products.dart';
import 'package:ulmo/features/product/presentation/controller/product_event.dart';
import 'package:ulmo/features/product/presentation/widgets/fliter_screen.dart';
import 'package:ulmo/features/product/presentation/widgets/product_details.dart';
import '../../../../core/di/di.dart';
import '../../../../core/models/product.dart';
import '../../../bag/presentation/controller/bag_bloc.dart';
import '../../../favorite/presentation/controller/favorite_bloc.dart';
import '../controller/product_bloc.dart';
import '../controller/product_state.dart';
import '../widgets/product_card.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/search_field.dart';

class ProductScreen extends StatelessWidget {
  final String? parentCategory;
  final String? parentid;

  const ProductScreen({
    Key? key,
    this.parentCategory,
    this.parentid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (innerContext) {
        // Schedule the product loading after build
        Future.microtask(() {
          innerContext.read<ProductBloc>().add(LoadProductsEvent(parentid ?? ""));
        });

        return Scaffold(
          appBar: AppBar(
            title: Text(parentCategory ?? ""),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   // SearchField(onChanged: (value) {}),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.sort),
                      color: AppColors.accentYellow,
                      splashRadius: 24,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FilterScreen()),
                        );
                      },
                      icon: const Icon(Icons.filter_alt),
                      color: AppColors.accentYellow,
                      splashRadius: 24,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProductLoaded) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) => ProductCard(
                          product: state.products[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(value: context.read<ProductBloc>()),
                                    BlocProvider.value(value: context.read<FavoriteBloc>()),
                                    BlocProvider.value(value: context.read<BagBloc>()),
                                  ],
                                  child: ProductDetailsPage(product: state.products[index]),
                                ),
                              ),
                            );





                          },
                        ),
                      );
                    } else if (state is ProductError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
