import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/view/category_screens/setup_app_categories.dart';
import 'package:newsapp/view/main_screens/home_view.dart';
import 'package:newsapp/view/main_screens_start.dart';
import 'package:newsapp/viewmodel/Categories_viewmodel.dart';
import 'package:newsapp/viewmodel/app_start_viewmodel.dart';
import 'package:newsapp/viewmodel/login_viewmodel.dart';
import 'package:newsapp/viewmodel/user_profile_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../model/services/database_helper.dart';
import '../viewmodel/setup_category_viewmodel.dart';
import 'loading_animations.dart';

class AppStart extends StatefulWidget {
  const AppStart({Key? key}) : super(key: key);

  @override
  State<AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {

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

  setCountryCode() async {
    SharedPreferences sharedPrefInside = await SharedPreferences.getInstance();
    if (sharedPrefInside.getString('countryCode') == null) {
      sharedPrefInside.setString('countryCode', 'eg');
    }
  }

  setCountry() async {
    SharedPreferences sharedPrefInside = await SharedPreferences.getInstance();
    if (sharedPrefInside.getString('country') == null) {
      sharedPrefInside.setString('country', 'egypt');
    }
  }

  setArticleLanguage() async {
    SharedPreferences sharedPrefInside = await SharedPreferences.getInstance();
    if (sharedPrefInside.getString('ArticleLanguage') == null) {
      sharedPrefInside.setString('ArticleLanguage', 'ar');
    }
  }

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    setAppId();
    setCountry();
    setCountryCode();
    setArticleLanguage();

    if (Provider.of<AppStartViewModel>(context, listen: false).setupCheck ==
        null)
      Future.delayed(Duration(seconds: 2), () {
        Provider.of<AppStartViewModel>(context, listen: false)
            .checkSetupCategories();

        //set Loggedin to true if user loggedin

        if (sharedpref!.getString('currentUser') != null) {
          Provider.of<LoginViewModel>(context, listen: false).setIsLogged(true);
          Provider.of<UserProfileViewModel>(context, listen: false)
              .fetchUserData();
        }
      });

    return Consumer<AppStartViewModel>(builder: (context, appStartVM, child) {
      if (appStartVM.setupCheck == 'true') {
        print('true2');

        Provider.of<CategoriesViewModel>(context, listen: false)
            .fetchCategoriesList();

        return Consumer<CategoriesViewModel>(
            builder: (context, categoriesViewModel, child) {
          print('inconsumer CategoriesViewModel from app start');

          print(
              "${categoriesViewModel.tabBarControllerLength} categoriesViewModel.tabBarControllerLength appstart");
          print(
              "${categoriesViewModel.idsList.length + 1} categoriesViewModel.idsList.length+1 appstart");

          if ((categoriesViewModel.tabBarControllerLength >=
                  categoriesViewModel.idsList.length + 1) &&
              (categoriesViewModel.idsList.length >= 1)) {
            print('in CategoriesViewModel from app start');

            if (sharedpref!.getString('currentUser') != null) {
              // Provider.of<UserProfileViewModel>(context,listen: false).fetchUserData();

              return Consumer<UserProfileViewModel>(
                  builder: (context, userProfileVM, child) {
                if (userProfileVM.fetchComplete) {
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainStart()),
                        (route) => false);
                  });
                  return SplashScreen();
                } else {
                  return SplashScreen();
                }
              });
            } else {
              print('in CategoriesViewModel from app start futuredely');
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainStart()),
                    (route) => false);
              });
              return SplashScreen();
            }
          }

          return SplashScreen();
        });
      } else if (appStartVM.setupCheck == 'false') {
        Provider.of<SetupCategoriesViewModel>(context, listen: false)
            .setAllSetupCategoriesMembersToEmpty();

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SetupAppCategories()),
              (route) => false);
        });

        return SplashScreen();
      } else {
        return SplashScreen();
      }
    });
  }
}
