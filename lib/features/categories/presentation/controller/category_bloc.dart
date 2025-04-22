import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/features/categories/domain/usecases/fetch_categories.dart';
import 'package:ulmo/features/categories/domain/usecases/fetch_child_categories.dart';

import '../../../../core/models/catagory.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FetchCategoriesUseCase fetchCategoriesUseCase;
  final FetchChildCategoriesUseCase fetchChildCategriesUseCase;
 List<Category> categories=[];

  CategoryBloc(this.fetchCategoriesUseCase,this.fetchChildCategriesUseCase) : super(CategoryInitial()) {
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
  }
}
