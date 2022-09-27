class ArticleCategory {
  final String categoryId;
  final String categoryName;

  ArticleCategory({required this.categoryId, required this.categoryName});

  factory ArticleCategory.fromJson(Map<String, dynamic> jsonData) {
    return ArticleCategory(
        categoryId: jsonData['categoryId'].runtimeType == String
            ? jsonData['categoryId']
            : jsonData['categoryId'].toString(),
        categoryName: jsonData['categoryName']);
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': int.parse((this.categoryId)),
      'categoryName': this.categoryName
    };
  }
}
