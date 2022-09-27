import 'package:flutter/material.dart';
import 'package:newsapp/view/authentication_screens/user_profile/user_profile.dart';
import 'package:newsapp/view/loading_animations.dart';
import 'package:newsapp/view/main_screens/account_view.dart';
import 'package:newsapp/view/app_start.dart';
import 'package:newsapp/view/category_screens/setup_app_categories.dart';
import 'package:newsapp/view/main_screens/home_view.dart';
import 'package:newsapp/view/authentication_screens/login_view.dart';
import 'package:newsapp/view/main_screens_start.dart';
import 'package:newsapp/view/authentication_screens/signup_view.dart';
import 'package:newsapp/view/category_screens/user_category_view.dart';
import 'package:newsapp/view/reset_news_app_data.dart';
import 'package:newsapp/viewmodel/Categories_viewmodel.dart';
import 'package:newsapp/viewmodel/app_start_viewmodel.dart';
import 'package:newsapp/viewmodel/article_list_viewmodel.dart';
import 'package:newsapp/viewmodel/login_viewmodel.dart';
import 'package:newsapp/viewmodel/setup_category_viewmodel.dart';
import 'package:newsapp/viewmodel/signup_viewmodel.dart';
import 'package:newsapp/viewmodel/user_profile_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'model/services/database_helper.dart';

SharedPreferences? sharedpref;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  setSharedpref() async {
    sharedpref = await SharedPreferences.getInstance();
  }

  setAppId() async {
    SharedPreferences sharedPrefInside = await SharedPreferences.getInstance();

    if (sharedPrefInside.getInt('appId') == null) {
      print('in get app id');
      DatabaseHelper instance = DatabaseHelper.instance;
      Database? db = await instance.database;
      List raw = await db!
          .query('user', where: "email = ?", whereArgs: ['newsapp@news.com']);
      Map appAsUserData = raw[0];
      await sharedPrefInside.setInt('appId', appAsUserData['userId']);
      print(appAsUserData['userId']);
    } else {
      print(sharedPrefInside.getInt('appId'));
      print('already exist app id');
    }
  }

  setCountry() async {
    SharedPreferences sharedPrefInside = await SharedPreferences.getInstance();
    if (sharedPrefInside.getString('country') == null) {
      sharedPrefInside.setString('country', 'egypt');
    }
  }

  setCountryCode() async {
    SharedPreferences sharedPrefInside = await SharedPreferences.getInstance();
    if (sharedPrefInside.getString('countryCode') == null) {
      sharedPrefInside.setString('countryCode', 'eg');
    }
  }

  setArticleLanguage() async {
    SharedPreferences sharedPrefInside = await SharedPreferences.getInstance();
    if (sharedPrefInside.getString('ArticleLanguage') == null) {
      sharedPrefInside.setString('ArticleLanguage', 'ar');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    setSharedpref();
    setAppId();
    setCountry();
    setCountryCode();
    setArticleLanguage();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ArticleListViewModel>(
            create: (context) => ArticleListViewModel()),
        ChangeNotifierProvider<LoginViewModel>(
            create: (context) => LoginViewModel()),
        ChangeNotifierProvider<SignupViewModel>(
            create: (context) => SignupViewModel()),
        ChangeNotifierProvider<CategoriesViewModel>(
            create: (context) => CategoriesViewModel()),
        ChangeNotifierProvider<SetupCategoriesViewModel>(
            create: (context) => SetupCategoriesViewModel()),
        ChangeNotifierProvider<AppStartViewModel>(
            create: (context) => AppStartViewModel()),
        ChangeNotifierProvider<UserProfileViewModel>(
            create: (context) => UserProfileViewModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'news cloud',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:AppStart(),
      ),
    );
  }
}
