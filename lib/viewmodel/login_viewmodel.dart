

import 'package:flutter/cupertino.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/model/model/user_model.dart';
import 'package:newsapp/model/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class LoginViewModel extends ChangeNotifier{

  final DatabaseHelper databaseHelperInstance=DatabaseHelper.instance;
  bool _isLogged=false;


  Future<String?> login(String email,String password)async {


    Database? db= await databaseHelperInstance.database;
    var raw= await db!.query('user',where:'email = ? ',whereArgs: [email] );
    Map<String,dynamic> userData=raw.isEmpty?{}:raw[0];

    print(email);
    print(password);
    print(raw);
    print(raw.runtimeType);

    if(raw.isNotEmpty){

      if(userData['password'] == password){

        return 'Successful login';
      }else{
        return 'password invalid';
      }

    }else{

      return 'email not found';
    }


  }

  logout()async{
    await sharedpref!.remove('currentUser').whenComplete((){
      _isLogged=false;
    });


  }

  setIsLogged(bool value){
    _isLogged=value;
  }

  bool get isLogged => _isLogged;

}