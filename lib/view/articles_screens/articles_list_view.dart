import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newsapp/viewmodel/article_list_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../model/model/article_model.dart';
import '../../model/model/category_model.dart';
import '../loading_animations.dart';
import 'article_description_webview.dart';

class ArticlesListCustomWidget extends StatefulWidget {
  ArticlesListCustomWidget(
      {Key? key,
      required this.tabViewWidgetName,
      this.mainScreenName = 'homeview'})
      : super(key: key);
  final String tabViewWidgetName;
  String mainScreenName;

  @override
  State<ArticlesListCustomWidget> createState() =>
      _ArticlesListCustomWidgetState(
          tabViewWidgetName: tabViewWidgetName, mainScreenName: mainScreenName);
}

class _ArticlesListCustomWidgetState extends State<ArticlesListCustomWidget> {
  _ArticlesListCustomWidgetState(
      {Key? key,
      required this.tabViewWidgetName,
      this.mainScreenName = 'homeview'});
  final String tabViewWidgetName;
  String mainScreenName;
  double height = 0.0;
  double width = 0.0;
  List<Article> listOfArticlesByCategory = [];
  ScrollController? searchListViewScrollController;

  _openBrowser(url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  _shareLink(url) {
    Share.share(url);
  }

  @override
  void initState() {
    super.initState();
    searchListViewScrollController = ScrollController();
    searchListViewScrollController!.addListener(() {
      if (searchListViewScrollController!.position.pixels ==
              searchListViewScrollController!.position.maxScrollExtent &&
          Provider.of<ArticleListViewModel>(context, listen: false).hasMore) {
        setState(() {
          Provider.of<ArticleListViewModel>(context, listen: false)
              .isLoadMoreRunning = true;
        });
      }

      if (Provider.of<ArticleListViewModel>(context, listen: false).hasMore &&
          Provider.of<ArticleListViewModel>(context, listen: false)
              .isLoadMoreRunning &&
          searchListViewScrollController!.position.pixels ==
              searchListViewScrollController!.position.maxScrollExtent) {
        Future.delayed(Duration(milliseconds: 200), () {
          print('in future dely flutter search//////////////////////////');
          Provider.of<ArticleListViewModel>(context, listen: false)
              .fetchLoadMoreArticlesByQuery(tabViewWidgetName);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    if (mainScreenName != 'homeview' &&
        mainScreenName.isNotEmpty &&
        mainScreenName.toLowerCase() == 'search') {

      return Consumer<ArticleListViewModel>(
          builder: (context, articleListViewModel, _) {

        // in this case tabViewWidgetName is the query

        if (articleListViewModel.articlesListByQuery.isEmpty) {
          // articleListViewModel.fetchArticlesByQuery(tabViewWidgetName);
          return ShimmerEffectNews();
        }

        if(articleListViewModel.queryHasError==null){
          return Container(height: 300,width: 300,child:Scaffold(backgroundColor: Colors.white,
            body: Center(child: Text('request limit exceeded ',style: TextStyle(color: Colors.red),),),
          ),);
        }

        if(articleListViewModel.queryHasError==true){
          return Container(height: 300,width: 300,child:Scaffold(backgroundColor: Colors.white,
            body: Center(child: Text('no result found ):',style: TextStyle(color: Colors.black),),),
          ),);

        }


        return Column(
          children: [
            Expanded(
                child: ListView.builder(
                    controller: searchListViewScrollController,
                    itemCount: articleListViewModel.articlesListByQuery.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            child: Container(
                              color: Colors.white,
                              height: height * (22 / 100),
                              width: width,
                              child: Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: width * (2 / 100))),
                                  Expanded(
                                      flex: 7,
                                      child: articleListViewModel
                                                  .articlesListByQuery[index]
                                                  .imageUrl ==
                                              'undefined'
                                          ? const Icon(Icons.image)
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              child: Container(
                                                  height: height * 0.15,
                                                  child: Image.network(
                                                    articleListViewModel
                                                        .articlesListByQuery[
                                                            index]
                                                        .imageUrl,
                                                    fit: BoxFit.cover,
                                                  )))),
                                  const Expanded(flex: 1, child: Text('')),
                                  Expanded(
                                    flex: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: height * (4.5 / 100))),
                                        Text(
                                          articleListViewModel
                                              .articlesListByQuery[index].title,
                                          maxLines: 4,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: height * (2.8 / 100))),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              Jiffy(articleListViewModel
                                                      .articlesListByQuery[
                                                          index]
                                                      .publishedAt)
                                                  .fromNow(),
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ArticleDescriptionWebView(
                                          url: articleListViewModel
                                              .articlesListByQuery[index]
                                              .url)));
                            },
                          ),
                          Row(
                            children: [
                              const Expanded(flex: 4, child: Text('        ')),
                              Expanded(
                                  flex: 2,
                                  child: IconButton(
                                      onPressed: () {
                                        _openBrowser(Uri.parse(
                                            articleListViewModel
                                                .articlesListByQuery[index]
                                                .url));
                                        print('chrome');
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.chrome,
                                        size: 18,
                                      ))),
                              Expanded(
                                  flex: 2,
                                  child: IconButton(
                                      onPressed: () {
                                        print('share');
                                        _shareLink(articleListViewModel
                                            .articlesListByQuery[index].url);
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.shareNodes,
                                        size: 20,
                                      ))),
                              const Expanded(flex: 4, child: Text('        ')),
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                          )
                        ],
                      );
                    })),
            if (articleListViewModel.isLoadMoreRunning)
              Container(
                color: Colors.white,
                height: 50,
                width: 50,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                )),
              ),
            if (!articleListViewModel.hasMore)
              Container(
                height: 60,
                width: width,
                color: Colors.yellow,
                child: Center(
                    child: Text(
                  'no more data to load',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )),
              )
          ],
        );
      });
    } else {
      if (tabViewWidgetName.toLowerCase() == 'top') {

        return Consumer<ArticleListViewModel>(
            builder: (context, articleListViewModel, _) {
          articleListViewModel.fetchArticlesByCountry(
              sharedpref!.getString('countryCode') == null
                  ? 'eg'
                  : (sharedpref!.getString('countryCode'))!);

          if (articleListViewModel.articlesList.isEmpty ||
              articleListViewModel.startCountry['top'] !=
                  sharedpref!.getString('country')) {
            Future.delayed(Duration(milliseconds: 100), () {
              articleListViewModel.startCountry['top'] =
                  (sharedpref!.getString('country'))!;

              articleListViewModel.fetchArticlesByCountry(
                  sharedpref!.getString('countryCode') == null
                      ? 'eg'
                      : (sharedpref!.getString('countryCode'))!);
            });
            return const ShimmerEffectNews();
          }

          if(articleListViewModel.topArticlesHasError==true){
            return Container(height: 300,width: 300,child:Scaffold(backgroundColor: Colors.white,
              body: Center(child:Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('you have lost your internet connection, ',style: TextStyle(color: Colors.red),),
                Text('or request limit exceeded ',style: TextStyle(color: Colors.red),)

              ],),),
            ),);
          }

          return ListView.builder(
              itemCount: articleListViewModel.articlesList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      child: Container(
                        color: Colors.white,
                        height: height * (22 / 100),
                        width: width,
                        child: Row(
                          children: [
                            Padding(
                                padding:
                                    EdgeInsets.only(left: width * (2 / 100))),
                            Expanded(
                                flex: 7,
                                child: articleListViewModel
                                            .articlesList[index].imageUrl ==
                                        'undefined'
                                    ? const Icon(Icons.image)
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        child: Container(
                                            height: height * 0.15,
                                            child: Image.network(
                                              articleListViewModel
                                                  .articlesList[index].imageUrl,
                                              fit: BoxFit.cover,
                                            )))),
                            const Expanded(flex: 1, child: Text('')),
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height * (4.5 / 100))),
                                  Text(
                                    articleListViewModel
                                        .articlesList[index].title,
                                    maxLines: 4,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height * (2.8 / 100))),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                        Jiffy(articleListViewModel
                                                .articlesList[index]
                                                .publishedAt)
                                            .fromNow(),
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArticleDescriptionWebView(
                                url: articleListViewModel
                                    .articlesList[index].url)));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Expanded(flex: 4, child: Text('        ')),
                        Expanded(
                            flex: 2,
                            child: IconButton(
                                onPressed: () {
                                  _openBrowser(Uri.parse(articleListViewModel
                                      .articlesList[index].url));
                                  print('chrome');
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.chrome,
                                  size: 18,
                                ))),
                        Expanded(
                            flex: 2,
                            child: IconButton(
                                onPressed: () {
                                  print('share');
                                  _shareLink(articleListViewModel
                                      .articlesList[index].url);
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.shareNodes,
                                  size: 20,
                                ))),
                        const Expanded(flex: 4, child: Text('        ')),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                    )
                  ],
                );
              });
        });
      } else {
        return Consumer<ArticleListViewModel>(
            builder: (context, articleListViewModel, _) {
          articleListViewModel.fetchArticlesByCategory(
              tabViewWidgetName,
              sharedpref!.getString('countryCode') == null
                  ? 'eg'
                  : (sharedpref!.getString('countryCode'))!);

          if (articleListViewModel.mapContainListOfCategories
                      .containsKey(tabViewWidgetName) ==
                  false ||
              articleListViewModel.startCountry[tabViewWidgetName] !=
                  sharedpref!.getString('country')) {
            /* Future.delayed(Duration(milliseconds:500),(){
              articleListViewModel.fetchArticlesByCategory(tabViewWidgetName,sharedpref!.getString('countryCode')==null?'eg':(sharedpref!.getString('countryCode'))!);
              print('///////////////////////////////////////////////////');
            });*/

            Future.delayed(Duration(milliseconds: 100), () {
              articleListViewModel.startCountry[tabViewWidgetName] =
                  (sharedpref!.getString('country'))!;

              articleListViewModel.fetchArticlesByCategory(
                  tabViewWidgetName,
                  sharedpref!.getString('countryCode') == null
                      ? 'eg'
                      : (sharedpref!.getString('countryCode'))!);
            });
            return ShimmerEffectNews();
          }

          if(articleListViewModel.categoryArticlesHasError==true){
            return Container(height: 300,width: 300,child:Scaffold(backgroundColor: Colors.white,
              body: Center(child:Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('you have lost your internet connection, ',style: TextStyle(color: Colors.red),),
                Text('or request limit exceeded ',style: TextStyle(color: Colors.red),)

              ],),),
            ),);
          }

          listOfArticlesByCategory = (articleListViewModel
              .mapContainListOfCategories[tabViewWidgetName])!;

          return ListView.builder(
              itemCount: listOfArticlesByCategory.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      child: Container(
                        color: Colors.white,
                        height: height * (22 / 100),
                        width: width,
                        child: Row(
                          children: [
                            Padding(
                                padding:
                                    EdgeInsets.only(left: width * (2 / 100))),
                            Expanded(
                                flex: 7,
                                child: listOfArticlesByCategory[index]
                                            .imageUrl ==
                                        'undefined'
                                    ? const Icon(Icons.image)
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        child: Container(
                                            height: height * 0.15,
                                            child: Image.network(
                                              listOfArticlesByCategory[index]
                                                  .imageUrl,
                                              fit: BoxFit.cover,
                                            )))),
                            const Expanded(flex: 1, child: Text('')),
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height * (4.5 / 100))),
                                  Text(
                                    listOfArticlesByCategory[index].title,
                                    maxLines: 4,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height * (2.8 / 100))),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                        Jiffy(listOfArticlesByCategory[index]
                                                .publishedAt)
                                            .fromNow(),
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArticleDescriptionWebView(
                                url: listOfArticlesByCategory[index].url)));
                      },
                    ),
                    Row(
                      children: [
                        const Expanded(flex: 4, child: Text('        ')),
                        Expanded(
                            flex: 2,
                            child: IconButton(
                                onPressed: () {
                                  _openBrowser(Uri.parse(
                                      listOfArticlesByCategory[index].url));
                                  print('chrome');
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.chrome,
                                  size: 18,
                                ))),
                        Expanded(
                            flex: 2,
                            child: IconButton(
                                onPressed: () {
                                  print('share');
                                  _shareLink(
                                      listOfArticlesByCategory[index].url);
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.shareNodes,
                                  size: 20,
                                ))),
                        const Expanded(flex: 4, child: Text('        ')),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                    )
                  ],
                );
              });
        });
      }
    }
  }
}
