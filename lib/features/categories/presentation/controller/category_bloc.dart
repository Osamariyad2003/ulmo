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

    // Properly implement debouncing using event transformer
    on<SearchCategories>(
      _onSearchCategories,
      transformer: _debounceTransformer(),
    );
  }

  // Separate method for handling search events
  Future<void> _onSearchCategories(
    SearchCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(CategoryLoading());

      print('Searching for: "${event.query}" in parent: ${event.parentId}');
      final searchResults = await categoriesRepo.searchCategories(
        event.parentId,
        event.query,
      );
      print('Search found ${searchResults.length} results');

      emit(CategoryLoaded(categories: searchResults));
    } catch (e) {
      print('Search error: ${e.toString()}');
      emit(CategoryError(message: e.toString()));
    }
  }

  // Create a debouncing event transformer
  EventTransformer<SearchCategories> _debounceTransformer() {
    return (events, mapper) {
      return events
          .debounce(const Duration(milliseconds: 300))
          .switchMap(mapper);
    };
  }
}
