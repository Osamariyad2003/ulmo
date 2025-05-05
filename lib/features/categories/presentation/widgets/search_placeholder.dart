import 'package:flutter/material.dart';

class SearchingPlaceholder extends StatelessWidget {
  final String searchQuery;

  const SearchingPlaceholder({Key? key, required this.searchQuery})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Searching for "$searchQuery"...'),
        ],
      ),
    );
  }
}

class NoSearchResultsPlaceholder extends StatelessWidget {
  final String query;

  const NoSearchResultsPlaceholder({Key? key, required this.query})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No categories match "$query"',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class StartSearchingPlaceholder extends StatelessWidget {
  const StartSearchingPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'Start typing to search categories',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
