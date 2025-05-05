import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shimmer/shimmer.dart';
import 'package:ulmo/core/di/di.dart';
import 'package:ulmo/features/product/data/repo/product_repo.dart';
import 'package:ulmo/features/product/presentation/controller/product_bloc.dart';
import 'package:ulmo/features/product/presentation/controller/product_state.dart';

import '../controller/favorite_bloc.dart';
import '../controller/favorite_event.dart';
import '../controller/favorite_state.dart';
import '../widgets/product_fav_card.dart';
import '../widgets/product_placeholder.dart';

class ProductFavScreen extends StatefulWidget {
  const ProductFavScreen({Key? key}) : super(key: key);

  @override
  State<ProductFavScreen> createState() => _ProductFavScreenState();
}

class _ProductFavScreenState extends State<ProductFavScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshFavorites();
    });
  }

  void _refreshFavorites() {
    context.read<FavoriteBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteBloc, FavoriteState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is FavoriteLoading;
        });

        if (state is FavoriteProductsNotFound) {
          _fetchProductsForIds(state.ids);
        }
      },
      builder: (context, state) {
        if (_isLoading) {
          return const FavoritesLoadingWidget();
        }

        if (state is FavoriteProductsNotFound) {
          return FavoritesFetchingWidget(idsCount: state.ids.length);
        }

        if (state is! FavoriteUpdated || state.favorites.isEmpty) {
          return const EmptyFavoritesWidget();
        }

        return FavoritesListWidget(
          products: state.favorites,
          onRefresh: _refreshFavorites,
        );
      },
    );
  }

  void _fetchProductsForIds(List<String> ids) async {
    if (ids.isEmpty) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final productsRepo = di<ProductsRepo>();
      final products = await productsRepo.getProductsByIds(ids);

      if (mounted) {
        context.read<FavoriteBloc>().add(UpdateFavoriteProducts(products));
      }
    } catch (e) {
      print("Error fetching products: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load favorite products: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

// Loading state widget
class FavoritesLoadingWidget extends StatelessWidget {
  const FavoritesLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            "Loading your favorites...",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class FavoritesFetchingWidget extends StatelessWidget {
  final int idsCount;

  const FavoritesFetchingWidget({
    Key? key,
    required this.idsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text("Loading $idsCount favorite products..."),
        ],
      ),
    );
  }
}

// Empty favorites widget
class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No favorite products available.",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Browse Products"),
          ),
        ],
      ),
    );
  }
}

// Favorites list widget
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
