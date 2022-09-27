class CategoriesList {
  final List<dynamic> categoriesList;

  CategoriesList({required this.categoriesList});

  factory CategoriesList.fromJson(Map<String, dynamic> jsonData) {
    return CategoriesList(categoriesList: jsonData['categories']);
  }
}
