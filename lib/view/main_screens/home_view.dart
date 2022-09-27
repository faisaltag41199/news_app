import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsapp/view/articles_screens/article_description_webview.dart';
import 'package:newsapp/viewmodel/Categories_viewmodel.dart';
import 'package:newsapp/viewmodel/article_list_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';
import '../articles_screens/articles_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late TabController _tabController;
  double height = 0.0;
  double width = 0.0;

  @override
  void initState() {
    _tabController = TabController(
        length: Provider.of<CategoriesViewModel>(context, listen: false)
            .tabBarControllerLength,
        vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
               isScrollable: true,
              labelPadding:
                  const EdgeInsets.only(left: 20, right: 15, bottom: 10),
              indicatorColor: Colors.black,
              labelStyle: const TextStyle(fontSize: 20),
              labelColor: Colors.black,
              controller: _tabController,
              tabs: Provider.of<CategoriesViewModel>(context, listen: false)
                  .categoriesTabBarList /*[Text('top'),Text('sport')]*/,
            ),
          ),
          title: const Text('news App'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: TabBarView(
          controller: _tabController,
          children: Provider.of<CategoriesViewModel>(context, listen: false)
              .categoriesTabBarViewList /*[
            ArticlesListCustomWidget(tabViewWidgetName:'Top'),
            ArticlesListCustomWidget(tabViewWidgetName:'sports')

          ]*/
          ,
        ),
      ),
    );
  }
}
