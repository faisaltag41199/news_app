
import 'package:flutter/cupertino.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/model/model/user_model.dart';
import 'package:newsapp/model/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class UserProfileViewModel extends ChangeNotifier{

  late User _user;
  DatabaseHelper _instance = DatabaseHelper.instance;
  Map<String,dynamic> tabbedItemsStatus={};
  Map<String,dynamic> _userProfileInfoWidgetdData={};
  bool fetchComplete=false;
  bool isDeleteImageRunning=false;
  Map<String,dynamic> itemsUpdateStatus={};





  updateFullName(String fullName)async{
    Database? db=await _instance.database;
    db!.update('user',{'fullName':fullName},where:'email = ?',whereArgs: [_user.email]).whenComplete((){
      _user.fullName=fullName;
      _userProfileInfoWidgetdData['fullName']=fullName;
      tabbedItemsStatus['fullName']='edit';
      itemsUpdateStatus['fullName']='done';

      notifyListeners();
    });

  }

  updateEmail(String email)async{

    Database? db=await _instance.database;
    db!.update('user',{'email':email},where:'email = ?',whereArgs: [_user.email]).whenComplete((){
      _user.email=email;
      _userProfileInfoWidgetdData['email']=email;
      tabbedItemsStatus['email']='edit';
      itemsUpdateStatus['email']='done';
      notifyListeners();
    });

  }

  updatePassword(String password)async{
    Database? db=await _instance.database;
    db!.update('user',{'password':password},where:'email = ?',whereArgs: [_user.email]).whenComplete((){
      _user.password=password;
      _userProfileInfoWidgetdData['password']=password;
      tabbedItemsStatus['password']='edit';
      itemsUpdateStatus['password']='done';
      notifyListeners();
    });
  }

  updateImage(String image)async{

    Database? db=await _instance.database;
    db!.update('user',{'imageUrl':image},where:'email = ?',whereArgs: [_user.email]).whenComplete((){
      _userProfileInfoWidgetdData['image']=image;
      _user.imageUrl=image;
      tabbedItemsStatus['image']='edit';
      itemsUpdateStatus['image']='done';
      notifyListeners();
    });
  }

  deleteImage()async{

    Database? db=await _instance.database;
    db!.update('user',{'imageUrl':'undefined'},where:'email = ?',whereArgs: [_user.email]).whenComplete((){
      _userProfileInfoWidgetdData['image']='undefined';
      _user.imageUrl='undefined';
      isDeleteImageRunning=false;
      notifyListeners();
    });
  }



  fetchUserData() async {

    Database? db=await _instance.database;
    int userId=int.parse((sharedpref!.getString("currentUser"))!);
    await db!.query('user',where:'userId = ?',whereArgs:[userId]).then((value){

      List<Map<String, Object?>> users=value;
      Map<String,dynamic> user=users[0];
      _user=User.fromJson(user);
      _userProfileInfoWidgetdData['fullName']=_user.fullName;
      _userProfileInfoWidgetdData['email']=_user.email;
      _userProfileInfoWidgetdData['password']=_user.password;
      _userProfileInfoWidgetdData['image']=_user.imageUrl;
      fetchComplete=true;
      print('in fetch user data////////////////////// user dataaaa/////');

      Future.delayed(Duration(milliseconds: 250),(){
        notifyListeners();
      });
    });


  }

  changeTabbedItemsStatus(String name,String status){

    if(tabbedItemsStatus.containsKey(name)){
      tabbedItemsStatus[name]=status;
      notifyListeners();
    }

  }

  setTabbedItemsStatus(String name,String status){
    tabbedItemsStatus[name]=status;
    notifyListeners();
  }

  changeIsDeleteImageRunning(bool value){
    isDeleteImageRunning=value;
    notifyListeners();
  }


  User get user => _user;
  Map<String,dynamic> get userProfileInfoWidgetdData => _userProfileInfoWidgetdData;

  /*set name(String name){
    _name=name;
    notifyListeners();
  }
  set email(String email){
    _email=email;
    notifyListeners();
  }
  set password(String password){
    _password=password;
    notifyListeners();
  }
  set image(String image){
    _image=image;
    notifyListeners();
  }
*/



}