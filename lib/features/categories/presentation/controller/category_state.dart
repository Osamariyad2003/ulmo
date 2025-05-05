abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<dynamic> categories;

  CategoryLoaded({required this.categories});
}

class CategorySearching extends CategoryState {
  final String query;

  CategorySearching(this.query);
}

class CategorySearchResults extends CategoryState {
  final List<dynamic> results;
  final String query;

  CategorySearchResults({required this.results, required this.query});

  @override
  List<Object?> get props => [results, query];
}

class CategorySearchEmpty extends CategoryState {
  final String query;

  CategorySearchEmpty(this.query);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError({required this.message});
}
