abstract class CategoryEvent {
  const CategoryEvent();
}

class FetchCategories extends CategoryEvent {}

class FetchChildCategories extends CategoryEvent {
  final String parentId;
  const FetchChildCategories({required this.parentId});
}

class SearchCategories extends CategoryEvent {
  final String parentId;
  final String query;
  const SearchCategories({required this.parentId, required this.query});
}
