import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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
        centerTitle: false,
        title: const Text("bag", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<BagBloc, BagState>(
        builder: (context, state) {
          if (state is BagLoading) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: const BagItemPlaceholder(),
                ),
              ),
            );
          }

          if (state is! BagLoaded) {
            return const Center(child: Text("Something went wrong."));
          }

          final bag = state.bag;
          final promoCode = bag.promoCode;

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ...bag.items.map(
                            (item) => ProductTile(
                          imageUrl: item.imageUrl,
                          title: item.name,
                          description:item.name,
                          price: item.price,
                          quantity: item.quantity,
                          onAdd: () => context.read<BagBloc>().add(AddQuantityEvent(item.productId)),
                          onRemove: () => context.read<BagBloc>().add(RemoveQuantityEvent(item.productId)),
                          onRemoveTile: () => context.read<BagBloc>().add(RemoveItemEvent(item.productId)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (promoCode?.isNotEmpty??false)
                        PromoCodeTile(
                          promoCode: promoCode??"",
                          onRemove: () => context.read<BagBloc>().add(ApplyPromoEvent("")),
                        )
                      else
                        TextField(
                          onSubmitted: (value) =>
                              context.read<BagBloc>().add(ApplyPromoEvent(value)),
                          decoration: InputDecoration(
                            hintText: "Enter promocode",
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.grey[100],
                            filled: true,
                          ),
                        ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            "\$${bag.total.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (bag.promoCode == '0')
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Promocode -\$${bag.promoCode??""}",
                            style: TextStyle(color: Colors.green[700], fontSize: 14),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                CustomButton(
                  label: "Continue",
                  onPressed: () {
                    Navigator.pushNamed(context, '/delivery');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

