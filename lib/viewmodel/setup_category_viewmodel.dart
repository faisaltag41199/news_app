
import 'package:flutter/cupertino.dart';
import 'package:newsapp/model/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../model/model/category_model.dart';


class SetupCategoriesViewModel extends ChangeNotifier{

  int numOfFollowedCategories=0;
  int setupComplete =0;
  List<ArticleCategory> listOfSetupCategoris=[];
  bool? isAllSetupCategoriesMembersSetToEmpty=false;

  DatabaseHelper instance=DatabaseHelper.instance;



  setAllSetupCategoriesMembersToEmpty(){
    numOfFollowedCategories=0;
    setupComplete=0;
    listOfSetupCategoris=[];
    isAllSetupCategoriesMembersSetToEmpty=true;
     notifyListeners();

  }
  void increase(){

      numOfFollowedCategories++;
      print(numOfFollowedCategories);
      notifyListeners();

  }

  void decrease(){
      numOfFollowedCategories--;
      notifyListeners();
  }

  addSetupCategory(ArticleCategory setupCategory){
    listOfSetupCategoris.add(setupCategory);
    print(setupCategory.toJson());
    notifyListeners();
  }

  removeSetupCategory(ArticleCategory setupCategory){

    for(int index=0;index<listOfSetupCategoris.length;index++){

      if(listOfSetupCategoris[index].categoryId==setupCategory.categoryId) {
        listOfSetupCategoris.removeAt(index);
        break;

      }

    }

    print(listOfSetupCategoris.length);
    notifyListeners();
  }

  saveAppSetupCategories(int appId) async {
   Database? db= await instance.database;


   listOfSetupCategoris.forEach((element)async {
     await db!.insert('user_category',{'userId':appId,'categoryId':int.parse(element.categoryId)});
     setupComplete++;
     print('$setupComplete from setupcategoVM');
     notifyListeners();

   });

  }


  saveUserSetupCategories(int? userId) async {
    Database? db= await instance.database;


    listOfSetupCategoris.forEach((element)async {
      await db!.insert('user_category',{'userId':userId,'categoryId':int.parse(element.categoryId)});
      setupComplete++;
      print('$setupComplete from setupcategoVM userAfterSignup');
      notifyListeners();

    });


  }



}