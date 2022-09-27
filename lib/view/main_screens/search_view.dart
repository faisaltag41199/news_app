import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/model/model/articles_list_model.dart';
import 'package:newsapp/viewmodel/article_list_viewmodel.dart';
import 'package:provider/provider.dart';

import '../articles_screens/articles_list_view.dart';
import '../loading_animations.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  double height = 600;
  double width = 500;
  String _query = 'egypt';
  bool _showSearchScreen = false;
  bool _isFoucesd = false;
  FocusNode _searchTextFieldNode = FocusNode();
  String? language = sharedpref!.getString('ArticleLanguage');
  List<String> articleLanguage = [
    'Arabic',
    'English',
    'German',
    'French',
    'Spanish',
    'Italian',
    'Chinese',
    'Russian'
  ];
  List<String> articleLanguageCode = [
    'ar',
    'en',
    'de',
    'fr',
    'es',
    'it',
    'zh',
    'ru'
  ];

  @override
  void initState() {
    _searchTextFieldNode.addListener(() {
      setState(() {
        _isFoucesd = !_isFoucesd;
      });
    });
    super.initState();
  }

  showBottomSheetFunc() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: 600,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: articleLanguage.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: index == 0 ? 120 : 70,
                    child: Column(
                      children: [
                        if (index == 0)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Articles Language",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        TextButton(
                            onPressed: () {
                              language = articleLanguageCode[index];
                              sharedpref!.setString("ArticleLanguage",
                                  articleLanguageCode[index]);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('tab to search')));
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              articleLanguage[index],
                              style: TextStyle(
                                  color: language == articleLanguageCode[index]
                                      ? Colors.blue
                                      : Colors.black),
                            )),
                        Divider(
                          color: Colors.grey,
                        )
                      ],
                    ),
                  );
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        width: width,
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 20, left: width * 0.025, right: width * 0.025),
              child: Container(
                width: width * 0.9,
                height: height * 0.125,
                child: Row(
                  children: [
                    Expanded(
                        flex: 9,
                        child: TextField(
                          focusNode: _searchTextFieldNode,
                          enableInteractiveSelection: true,
                          autocorrect: true,
                          keyboardType: TextInputType.url,
                          onChanged: (value) {
                            setState(() {
                              if (value != _query) {
                                _showSearchScreen = false;
                              }
                              _query = value;
                            });
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(color: Colors.black)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(color: Colors.grey)),
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (language == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'select article language to search')));
                                } else {
                                  Provider.of<ArticleListViewModel>(context,
                                          listen: false)
                                      .setarticlesListByQueryToEmpty();

                                  setState(() {
                                    _showSearchScreen = true;
                                  });

                                  Provider.of<ArticleListViewModel>(context,
                                          listen: false)
                                      .fetchArticlesByQuery(_query);
                                }
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.magnifyingGlass,
                                size: 18,
                                color: _isFoucesd ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            showBottomSheetFunc();
                          },
                          icon: FaIcon(FontAwesomeIcons.ellipsisVertical),
                        ))
                  ],
                ),
              ),
            ),
            Container(
              height: height * 0.73,
              width: width,
              child: _showSearchScreen == true
                  ? ArticlesListCustomWidget(
                      tabViewWidgetName: _query,
                      mainScreenName: 'search',
                    )
                  : LottieSearch(),
            )
          ],
        ),
      ),
    );
  }
}
