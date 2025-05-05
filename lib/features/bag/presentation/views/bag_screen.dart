import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';
import 'package:ulmo/core/app_router/routers.dart';

import '../../../../core/utils/widgets/custom_button.dart';
import '../controller/bag_bloc.dart';
import '../controller/bag_event.dart';
import '../controller/bag_state.dart';
import '../widgets/bagItemPlaceholder.dart';
import '../widgets/product_tile.dart';
import '../widgets/promocode_tile.dart';

class BagScreen extends StatelessWidget {
  const BagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "bag",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<BagBloc, BagState>(
        builder: (context, state) {
          if (state is BagLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! BagLoaded) {
            return const Center(child: Text("Something went wrong."));
          }

          final bag = state.bag;
          final promoCode = bag.promoCode ?? "";

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: bag.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = bag.items[index];
                      return ProductTile(
                        imageUrl: item.imageUrl,
                        title: item.name,
                        description: item.name,
                        price: item.price,
                        quantity: item.quantity,
                        onAdd:
                            () => context.read<BagBloc>().add(
                              AddQuantityEvent(item.productId),
                            ),
                        onRemove:
                            () => context.read<BagBloc>().add(
                              RemoveQuantityEvent(item.productId),
                            ),
                        onRemoveTile:
                            () => context.read<BagBloc>().add(
                              RemoveItemEvent(item.productId),
                            ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                promoCode.isNotEmpty
                    ? PromoCodeTile(
                      promoCode: promoCode,
                      onRemove:
                          () =>
                              context.read<BagBloc>().add(ApplyPromoEvent("")),
                    )
                    : TextField(
                      onSubmitted:
                          (value) => context.read<BagBloc>().add(
                            ApplyPromoEvent(value),
                          ),
                      decoration: InputDecoration(
                        hintText: "Promocode",
                        prefixIcon: const Icon(Icons.local_offer_outlined),
                        suffixIcon: const Icon(Icons.check_circle_outline),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                const SizedBox(height: 16),
                // if (bag.items.isNotEmpty) ...[
                //   const Text(
                //     "Items in bag:",
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                //   const SizedBox(height: 8),
                //   Container(
                //     padding: const EdgeInsets.all(8),
                //     decoration: BoxDecoration(
                //       color: Colors.grey[100],
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         for (var item in bag.items)
                //             Text("ID: ${item.productId.substring(0, Math.min(8, item.productId.length))}... | ${item.name} | Qty: ${item.quantity}",                         ),
                //       ],
                //     ),
                //   ),
                //   const SizedBox(height: 16),
                // ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "total",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "\$${bag.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      label: "Continue",
                      onPressed:
                          () => Navigator.pushNamed(context, Routes.delivery),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
