import 'package:newsapp/model/model/article_model.dart';

class ArticlesList {
  final List<dynamic>? articlesList;

  ArticlesList({this.articlesList});

  factory ArticlesList.fromJson(Map<String, dynamic> jsonData) {
    return ArticlesList(articlesList: jsonData['articles']);
  }
}
