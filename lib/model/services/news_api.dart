import 'dart:convert';

import 'package:newsapp/model/model/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/model/model/articles_list_model.dart';

void main() async {
  List<Article>? listo = await NewsApi().fetchArticlesByCountry('eg');
  for (int i = 0; i < listo!.length; i++) {
    print(listo[i].imageUrl);
  }
}

class NewsApi {
  final String _apiKey = "aa1d8f8cfef34f8d83d0619b2d931ec1";

  Future<List<Article>?> fetchArticlesByCountry(String country) async {
    try {
      var url = Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=$country&apiKey=$_apiKey');
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        ArticlesList articlesListObject = ArticlesList.fromJson(jsonData);
        List<Article> articlesList = articlesListObject.articlesList!
            .map((e) => Article.fromJson(e))
            .toList();
        return articlesList;
      } else {
        print('error response status code : ${response.statusCode}');
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future<List<Article>?> fetchArticlesByCategory(
      String category, String country) async {
    try {
      var url = Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=$country&apiKey=$_apiKey&category=$category');
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        ArticlesList articlesListObject = ArticlesList.fromJson(jsonData);
        List<Article> articlesList = articlesListObject.articlesList!
            .map((e) => Article.fromJson(e))
            .toList();
        return articlesList;
      } else {
        print('error response status code : ${response.statusCode}');
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future<List<Article>?> fetchArticlesByQuery(
      String query, int page, String language) async {
    try {
      var url = Uri.parse(
          'https://newsapi.org/v2/everything?q=$query&language=$language&sortBy=publishedAt&apiKey=$_apiKey'
          '&pageSize=15&page=$page');
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        ArticlesList articlesListObject = ArticlesList.fromJson(jsonData);
        List<Article> articlesList = articlesListObject.articlesList!
            .map((e) => Article.fromJson(e))
            .toList();
        return articlesList;
      } else {
        print('error response status code : ${response.statusCode}');
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future<List<Article>?> fetchLoadMoreArticlesByQuery(
      String query, int page, String language) async {
    try {
      var url = Uri.parse(
          'https://newsapi.org/v2/everything?q=$query&language=$language&sortBy=publishedAt&apiKey=$_apiKey'
          '&pageSize=15&page=$page');
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        ArticlesList articlesListObject = ArticlesList.fromJson(jsonData);
        List<Article> articlesList = articlesListObject.articlesList!
            .map((e) => Article.fromJson(e))
            .toList();
        return articlesList;
      } else {
        print('error response status code : ${response.statusCode}');
      }
    } catch (ex) {
      print(ex);
    }
  }
}
