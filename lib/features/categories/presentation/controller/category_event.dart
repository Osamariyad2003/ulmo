
abstract class CategoryEvent  {
  const CategoryEvent();

}

class FetchCategories extends CategoryEvent {}

class FetchChildCategories extends CategoryEvent {
  final String parentId;
  const FetchChildCategories({required this.parentId});
}

