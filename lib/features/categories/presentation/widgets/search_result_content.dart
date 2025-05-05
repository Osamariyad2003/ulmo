import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/features/categories/presentation/controller/category_bloc.dart';
import 'package:ulmo/features/categories/presentation/controller/category_state.dart';
import 'package:ulmo/features/categories/presentation/widgets/category_search_list.dart';
import 'package:ulmo/features/categories/presentation/widgets/search_placeholder.dart';

class SearchResultsView extends StatelessWidget {
  final TextEditingController searchController;

  const SearchResultsView({Key? key, required this.searchController})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listenWhen:
          (previous, current) =>
              current is CategorySearchResults ||
              current is CategorySearchEmpty,
      listener: (context, state) {
        print(
          "BlocConsumer listener triggered with state: ${state.runtimeType}",
        );
        if (state is CategorySearchResults) {
          print(
            "Listener: Search returned ${state.results.length} results for '${state.query}'",
          );
        } else if (state is CategorySearchEmpty) {
          print("Listener: Search returned no results for '${state.query}'");
        }
      },
      buildWhen: (previous, current) {
        print(
          "buildWhen called: previous=${previous.runtimeType}, current=${current.runtimeType}",
        );
        return true;
      },
      builder: (context, state) {
        print("Building search results with state: ${state.runtimeType}");

        // Print detailed information about the state
        if (state is CategorySearchResults) {
          print("Builder has ${state.results.length} results");
          for (var i = 0; i < state.results.length; i++) {
            try {
              print("Result $i: ${state.results[i].name}");
            } catch (e) {
              print("Error accessing result $i: $e");
            }
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchResultsHeader(state: state),
            const SizedBox(height: 8),
            // Show search results based on state
            Expanded(
              child: SearchResultsContent(
                state: state,
                searchQuery: searchController.text,
              ),
            ),
          ],
        );
      },
    );
  }
}

class SearchResultsHeader extends StatelessWidget {
  final CategoryState state;

  const SearchResultsHeader({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Search Results',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (state is CategorySearchResults)
          Text(
            '${(state as CategorySearchResults).results.length} results',
            style: TextStyle(color: Colors.grey[600]),
          )
        else if (state is CategorySearchEmpty)
          Text('0 results', style: TextStyle(color: Colors.grey[600]))
        else
          Text('0 results', style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }
}

class SearchResultsContent extends StatelessWidget {
  final CategoryState state;
  final String searchQuery;

  const SearchResultsContent({
    Key? key,
    required this.state,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building search results content with state: ${state.runtimeType}");

    if (state is CategorySearchResults) {
      print(
        "State has ${(state as CategorySearchResults).results.length} results for query '${(state as CategorySearchResults).query}'",
      );
      if ((state as CategorySearchResults).results.isNotEmpty) {
        print(
          "First result: ${(state as CategorySearchResults).results[0].name}, ID: ${(state as CategorySearchResults).results[0].id}",
        );
      }
      return CategorySearchResultsList(
        results: (state as CategorySearchResults).results,
      );
    } else if (state is CategorySearching) {
      return SearchingPlaceholder(searchQuery: searchQuery);
    } else if (state is CategorySearchEmpty) {
      return NoSearchResultsPlaceholder(
        query: (state as CategorySearchEmpty).query,
      );
    } else {
      return StartSearchingPlaceholder();
    }
  }
}
