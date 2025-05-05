import 'package:flutter/material.dart';

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
