import 'package:flutter/material.dart';
import 'package:ulmo/features/favorite/presentation/widgets/product_fav_card.dart';

class FavoritesListWidget extends StatelessWidget {
  final List<dynamic> products;
  final VoidCallback onRefresh;

  const FavoritesListWidget({
    Key? key,
    required this.products,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: products.isEmpty
            ? Center(
                child: Text(
                  "Pull down to refresh favorites",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return FavCard(product: products[index]);
                },
              ),
      ),
    );
  }
}
