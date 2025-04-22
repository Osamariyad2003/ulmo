import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shimmer/shimmer.dart';
import 'package:ulmo/features/product/presentation/controller/product_bloc.dart';

import '../controller/favorite_bloc.dart';
import '../controller/favorite_state.dart';
import '../widgets/product_fav_card.dart';
import '../widgets/product_placeholder.dart';


class ProductFavScreen extends StatelessWidget {
  const ProductFavScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        if (state is! FavoriteUpdated || state.favorites.isEmpty) {
          return const Center(child: Text("No favorite products available."));
        }

        final products = state.favorites;

        return Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return FavCard(product: products[index]);
            },
          ),
        );
      },
    );
  }
}


