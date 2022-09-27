import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:newsapp/view/main_screens/account_view.dart';
import 'package:newsapp/view/main_screens/home_view.dart';
import 'package:newsapp/view/main_screens/search_view.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:newsapp/viewmodel/article_list_viewmodel.dart';
import 'package:provider/provider.dart';


class MainStart extends StatefulWidget {
  const MainStart({Key? key}) : super(key: key);

  @override
  State<MainStart> createState() => _MainStartState();
}

class _MainStartState extends State<MainStart> {
  bool hasConnection=true;
  int _selectedIndex = 0;
  List<Widget> widgetOptionsList = [HomeView(), SearchView(), AccountView()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        Provider.of<ArticleListViewModel>(context,listen:false).queryHasError=!(status==InternetConnectionStatus.connected);
        Provider.of<ArticleListViewModel>(context,listen:false).categoryArticlesHasError=!(status==InternetConnectionStatus.connected);
        Provider.of<ArticleListViewModel>(context,listen:false).topArticlesHasError=!(status==InternetConnectionStatus.connected);

        hasConnection= status==InternetConnectionStatus.connected;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_selectedIndex== 0 || _selectedIndex == 1 ?
          hasConnection? widgetOptionsList[_selectedIndex] :
          Center(child:Text('you are currently offline',style: TextStyle(color: Colors.black),),)
              :widgetOptionsList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: Colors.black),
        elevation: 10,
        items: [
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(10),
                child: FaIcon(FontAwesomeIcons.house),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(10),
                child: FaIcon(FontAwesomeIcons.magnifyingGlass),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(10),
                child: FaIcon(
                  FontAwesomeIcons.user,
                ),
              ),
              label: ''),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
