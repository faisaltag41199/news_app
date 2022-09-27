import 'package:flutter/material.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/model/model/article_model.dart';
import 'package:newsapp/model/services/news_api.dart';

class ArticleListViewModel extends ChangeNotifier {
  List<Article> _articlesList = [];
  List<Article> _articlesListByCategory = [];
  Map<String, List<Article>> _mapContainListOfCategories = {};
  String _currentCategory = '';
  Map<String, String> startCountry = {};
  List<Article> _articlesListByQuery = [];
  List<Article>? _loadMoreArticlesListByQuery = [];
  int page = 1;
  bool isLoadMoreRunning = false;
  bool hasMore = true;
  bool topArticlesHasError=false;
  bool categoryArticlesHasError=false;
  bool? queryHasError=false;


  fetchArticlesByCountry(String country) async {

    List<Article>? topResponseChecker = await NewsApi().fetchArticlesByCountry(country);
    _currentCategory = 'top';

    if(topResponseChecker==null){
      topArticlesHasError=true;
       notifyListeners();
    }else if(topResponseChecker.isEmpty){

      topArticlesHasError=true;
      notifyListeners();

    }else{
       topArticlesHasError=false;
      _articlesList =topResponseChecker;

      notifyListeners();
    }

  }

  fetchArticlesByCategory(String category, String country) async {


    List<Article>? categoryResponseChecker = await NewsApi().fetchArticlesByCategory(category, country);
    _currentCategory = category;

    if(categoryResponseChecker==null){
      categoryArticlesHasError=true;
      notifyListeners();
    }else if(categoryResponseChecker.isEmpty){

      categoryArticlesHasError=true;
      notifyListeners();

    }else{

       categoryArticlesHasError=false;
      _mapContainListOfCategories[category] =categoryResponseChecker;

      notifyListeners();
    }




  }

  fetchArticlesByQuery(String query) async {

    page = 1;
    hasMore = true;

    List<Article>? queryResponseChecker = await NewsApi().fetchArticlesByQuery(
        query, page, (sharedpref!.getString('ArticleLanguage'))!);


    if(queryResponseChecker==null){
      queryHasError=null;
      notifyListeners();

    }else if(queryResponseChecker.isEmpty){

      queryHasError=true;
      notifyListeners();

    }else{

      queryHasError=false;
      _articlesListByQuery =queryResponseChecker;


      notifyListeners();
    }

  }

  fetchLoadMoreArticlesByQuery(String query) async {
    page = page + 1;
    print('paaaaaaaaaaaaage num = $page');

    _loadMoreArticlesListByQuery = await NewsApi().fetchLoadMoreArticlesByQuery(
        query, page, (sharedpref!.getString('ArticleLanguage'))!);

    if (_loadMoreArticlesListByQuery == null) {
      hasMore = false;
      isLoadMoreRunning = false;
      notifyListeners();
    } else if (_loadMoreArticlesListByQuery!.isEmpty) {
      hasMore = false;
      isLoadMoreRunning = false;
      notifyListeners();
    } else {
      _articlesListByQuery.addAll(_loadMoreArticlesListByQuery!);
      print('_articlesListByQuery.length ${_articlesListByQuery.length}');
      isLoadMoreRunning = false;
      notifyListeners();
    }
  }

  setarticlesListByQueryToEmpty() {
    _articlesListByQuery = [];
  }

  List<Article> get articlesList => _articlesList;
  Map<String, List<Article>> get mapContainListOfCategories =>
      _mapContainListOfCategories;
  List<Article> get articlesListByCategory => _articlesListByCategory;
  List<Article> get articlesListByQuery => _articlesListByQuery;
  String get currentCategory => _currentCategory;
// List<Article> get loadMoreArticlesListByQuery => _loadMoreArticlesListByQuery;

}
