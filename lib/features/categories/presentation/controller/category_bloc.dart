import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:ulmo/features/categories/domain/usecases/fetch_categories.dart';
import 'package:ulmo/features/categories/domain/usecases/fetch_child_categories.dart';

import '../../../../core/models/catagory.dart';
import '../../data/repo/category_repo_impl.dart';
import 'category_event.dart';
import 'category_state.dart';

// Extension for adding debounce to the event stream
extension on EventTransformer<SearchCategories> {
  EventTransformer<SearchCategories> debounce(Duration duration) {
    return (events, mapper) {
      return events.debounce(duration).switchMap(mapper);
    };
  }
}

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FetchCategoriesUseCase fetchCategoriesUseCase;
  final FetchChildCategoriesUseCase fetchChildCategriesUseCase;
  final CategoriesRepo categoriesRepo;
  List<Category> categories = [];

  CategoryBloc(
    this.fetchCategoriesUseCase,
    this.fetchChildCategriesUseCase,
    this.categoriesRepo,
  ) : super(CategoryInitial()) {
    on<FetchCategories>((event, emit) async {
      try {
        emit(CategoryLoading());
        categories = await fetchCategoriesUseCase.call();
        emit(CategoryLoaded(categories: categories));
      } catch (e) {
        emit(CategoryError(message: e.toString()));
      }
    });

    on<FetchChildCategories>((event, emit) async {
      try {
        emit(CategoryLoading());
        final childCategories = await fetchChildCategriesUseCase.call(
          parentId: event.parentId,
        );
        emit(CategoryLoaded(categories: childCategories));
      } catch (e) {
        emit(CategoryError(message: e.toString()));
      }
    });

    on<SearchCategories>((event, emit) async {
      try {
        emit(CategorySearching(event.query));

        print("Searching for: \"${event.query}\" in parent: ${event.parentId}");

        final searchResults = await categoriesRepo.searchCategories(
          event.parentId,
          event.query,
        );
        print(
          "Search query: \"${event.query}\", Found ${searchResults.length} results",
        );

        if (searchResults.isNotEmpty) {
          emit(
            CategorySearchResults(results: searchResults, query: event.query),
          );
          print("Search found ${searchResults.length} results");

          for (var item in searchResults) {
            print("Result: ${item.name}, ID: ${item.id}");
          }
        } else {
          // Emit empty state if no results
          emit(CategorySearchEmpty(event.query));
          print("No results found for '${event.query}'");
        }
      } catch (e) {
        print("Search error: ${e.toString()}");
        emit(CategoryError(message: "Search failed: ${e.toString()}"));
      }
    }, transformer: _debounceTransformer());

    on<UpdateSearchResults>((event, emit) {
      final currentState = state;
      if (currentState is CategorySearchResults) {
        emit(
          CategorySearchResults(
            results: event.results,
            query: currentState.query,
          ),
        );
        print(
          "Updated search results: ${event.results.length} items for query '${currentState.query}'",
        );
      } else {
        emit(CategorySearchResults(results: event.results, query: ""));
        print("Updated search results: ${event.results.length} items");
      }
    });
  }

 EventTransformer<SearchCategories> _debounceTransformer() {
    return (events, mapper) {
      return events
          .debounce(const Duration(milliseconds: 300))
          .switchMap(mapper);
    };
  }
}
