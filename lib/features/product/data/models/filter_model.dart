class FilterOptions {
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? mainMaterial;
  final bool sortByPriceDescending;

  FilterOptions({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.mainMaterial,
    this.sortByPriceDescending = false,
  });
}
