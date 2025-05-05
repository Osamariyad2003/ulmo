abstract class CategoryEvent {}

class FetchCategories extends CategoryEvent {}

class FetchChildCategories extends CategoryEvent {
  final String parentId;

  FetchChildCategories({required this.parentId});
}

class SearchCategories extends CategoryEvent {
  final String parentId;
  final String query;

  SearchCategories({required this.parentId, required this.query});
}

class UpdateSearchResults extends CategoryEvent {
  final List<dynamic> results;

  UpdateSearchResults({required this.results});
}
