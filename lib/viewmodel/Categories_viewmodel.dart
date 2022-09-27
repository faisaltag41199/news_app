

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/model/model/category_list_model.dart';
import 'package:newsapp/model/model/category_model.dart';
import 'package:newsapp/model/services/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../view/articles_screens/articles_list_view.dart';


class CategoriesViewModel extends ChangeNotifier{

  DatabaseHelper instance=DatabaseHelper.instance;

  //SaveAndRemoveCategoriesMembers
  List<ArticleCategory> _removedcategoriesList = [];//removedcategories that already in database
  List<ArticleCategory> _newcategoriesList = []; //new followed categories
  List<ArticleCategory> _categoriesList = [];
  int saveCategoriesComplete=0;
  int removeCategoriesOnlyComplete=0;
  bool afterSaveNewCategories=false;
  bool afterRemoveOnlyCategories=false;


  //FetchCategoriesMembers
  List<Tab> _categoriesTabBarList=[Tab(text:'top',)];
  List<Widget> _categoriesTabBarViewList=[ArticlesListCustomWidget(tabViewWidgetName:'top')];
  int _tabBarControllerLength=1;
  List idsList=[];


  fetchCategoriesList() async{
    DatabaseHelper instance=DatabaseHelper.instance;
    Database? database=await instance.database;

    setAllCategoriesListsToEmpty();

    if(sharedpref!.getString('currentUser')==null){

     idsList = await database!.query('user_category',where: 'userId = ?',whereArgs:[sharedpref!.getInt('appId')]);
     idsList.forEach((element) async{

     print('$idsList fromcatego VM idslist length ${idsList.length} ');
     var raw = await database.query('category',where:'categoryId = ?',whereArgs:[element['categoryId']]);
     Map<String,dynamic> articleCategory=raw[0];

      print('$articleCategory from categoVM article category');
     _categoriesList.add(ArticleCategory.fromJson(articleCategory));
     _categoriesTabBarList.add(Tab(text:articleCategory['categoryName']));
     _categoriesTabBarViewList.add(ArticlesListCustomWidget(tabViewWidgetName:articleCategory['categoryName']));
     _tabBarControllerLength++;
     print('tabbarcontroller from categovm $_tabBarControllerLength');

     notifyListeners();
     });


   }else{

      print('');

      idsList = await database!.query('user_category',where: 'userId = ?',whereArgs:[int.parse((sharedpref!.getString('currentUser'))!)]);
      idsList.forEach((element) async{

       print('$idsList fromcatego VM idslist length ${idsList.length} ');
       var raw= await database.query('category',where:'categoryId = ?',whereArgs:[element['categoryId']]);
       Map<String,dynamic> articleCategory=raw[0];

       print('$articleCategory from categoVM article category');
       _categoriesList.add(ArticleCategory.fromJson(articleCategory));
       _categoriesTabBarList.add(Tab(text:articleCategory['categoryName']));
       _categoriesTabBarViewList.add(ArticlesListCustomWidget(tabViewWidgetName:articleCategory['categoryName']));
       _tabBarControllerLength++;
       print('tabbarcontroller from categovm $_tabBarControllerLength');

       notifyListeners();
     });



   }

  }

  addCategory(ArticleCategory userCategory){
    int? isInRemovedList=_removedcategoriesList.indexWhere((element) => userCategory.categoryId==element.categoryId);

    print('in add category');
    print('index of element $isInRemovedList in isInRemovedList');

    if(isInRemovedList != -1){

      print('in added catego remove from removedlist');

      _removedcategoriesList.removeAt(isInRemovedList);
      notifyListeners();
      
      
    }else{
      
      _newcategoriesList.add(userCategory);
      print(' userCatego add in newcategolist');
      notifyListeners();
      
    }



  }

  removeCategory(ArticleCategory userCategory){
    print('in remove category');
    print('${userCategory.categoryId.runtimeType} + ${userCategory.categoryId} usercategory from buttonclass');
    _categoriesList.forEach((element) {
      print('${element.categoryId.runtimeType} + ${element.categoryId}  from categpory vm');
    });


    int? isInCategoriesList=_categoriesList.indexWhere((element) => userCategory.categoryId==element.categoryId);
    print(isInCategoriesList);
    if(isInCategoriesList != -1){

      print(' in removedcateego . remove');
      _removedcategoriesList.add(userCategory);
      notifyListeners();


    }else{

      _newcategoriesList.removeWhere((element) => element.categoryId==userCategory.categoryId);
      notifyListeners();

    }



  }

  

  saveAppCategoriesList(int appId)async{


    Database? db= await instance.database;
    int removedComplete=0;



    if(_removedcategoriesList.isNotEmpty){

      _removedcategoriesList.forEach((element)async {
        removedComplete++;
        await db!.delete('user_category',where:'userId = ? AND categoryId = ? ',whereArgs:[appId,int.parse(element.categoryId)])
            .whenComplete(() async{
              if(removedComplete >= _removedcategoriesList.length){

                setAllCategoriesListsToEmpty();
                _newcategoriesList.forEach((element)async {
                  await db.insert('user_category',{'userId':appId,'categoryId':int.parse(element.categoryId)});
                  saveCategoriesComplete++;
                  print('$saveCategoriesComplete from setupcategoVM');

                  if(saveCategoriesComplete>=_newcategoriesList.length){
                    afterSaveNewCategories=true;
                  }
                  notifyListeners();

                });

              }
        });
      });


    }else{

       setAllCategoriesListsToEmpty();
      _newcategoriesList.forEach((element)async {
        await db!.insert('user_category',{'userId':appId,'categoryId':int.parse(element.categoryId)});
        saveCategoriesComplete++;
        print('$saveCategoriesComplete from setupcategoVM');

        if(saveCategoriesComplete>=_newcategoriesList.length){
          afterSaveNewCategories=true;
        }
        notifyListeners();

        });
      }

  }

  saveUserCategoriesList(int userId)async{


    Database? db= await instance.database;
    int removedComplete=0;



    if(_removedcategoriesList.isNotEmpty){

      _removedcategoriesList.forEach((element)async {
        removedComplete++;
        await db!.delete('user_category',where:'userId = ? AND categoryId = ? ',whereArgs:[userId,int.parse(element.categoryId)])
            .whenComplete(() async{
          if(removedComplete >= _removedcategoriesList.length){

            setAllCategoriesListsToEmpty();
            _newcategoriesList.forEach((element)async {
              await db.insert('user_category',{'userId':userId,'categoryId':int.parse(element.categoryId)});
              saveCategoriesComplete++;
              print('$saveCategoriesComplete from setupcategoVM');



              if(saveCategoriesComplete>=_newcategoriesList.length){
                afterSaveNewCategories=true;
              }
             notifyListeners();

            });

          }
        });
      });


    }else{

      setAllCategoriesListsToEmpty();
      _newcategoriesList.forEach((element)async {

        await db!.insert('user_category',{'userId':userId,'categoryId':int.parse(element.categoryId)});
        saveCategoriesComplete++;

        print('$saveCategoriesComplete from setupcategoVM');

        if(saveCategoriesComplete>=_newcategoriesList.length){
          afterSaveNewCategories=true;
        }


        notifyListeners();

      });
    }

  }

  removeAppCategoriesList(int appId)async{

    Database? db= await instance.database;
    setAllCategoriesListsToEmpty();

    _removedcategoriesList.forEach((element)async {

      await db!.delete('user_category',where:'userId = ? AND categoryId = ? ',whereArgs:[appId,int.parse(element.categoryId)])
          .whenComplete(() async{

        removeCategoriesOnlyComplete++;

        if(removeCategoriesOnlyComplete>=_removedcategoriesList.length){
          afterRemoveOnlyCategories=true;
        }

        notifyListeners();


      });
    });


  }

  removeUserCategoriesList(int userId)async{

    Database? db= await instance.database;
    setAllCategoriesListsToEmpty();

    _removedcategoriesList.forEach((element)async {

      await db!.delete('user_category',where:'userId = ? AND categoryId = ? ',whereArgs:[userId,int.parse(element.categoryId)])
          .whenComplete(() async{

        removeCategoriesOnlyComplete++;
        if(removeCategoriesOnlyComplete>=_removedcategoriesList.length){
          afterRemoveOnlyCategories=true;
        }
        notifyListeners();


      });
    });

  }

  setnewCategoriesListToEmpty(){
    _newcategoriesList=[];
  }

  setremovedCategoriesListToEmpty(){
    _removedcategoriesList=[];
  }

  setAllCategoriesListsToEmpty(){

    _categoriesList = [];
    _categoriesTabBarList=[Tab(text:'top',)];
    _categoriesTabBarViewList=[ArticlesListCustomWidget(tabViewWidgetName:'top')];
    _tabBarControllerLength=1;
    idsList=[];


  }



  List<ArticleCategory> get categoriesList => _categoriesList ;
  List<ArticleCategory> get newCategoriesList => _newcategoriesList ;
  List<ArticleCategory> get removedCategoriesList => _removedcategoriesList ;

  List<Tab> get categoriesTabBarList => _categoriesTabBarList ;
  List<Widget> get categoriesTabBarViewList => _categoriesTabBarViewList ;
  int get tabBarControllerLength => _tabBarControllerLength ;



}