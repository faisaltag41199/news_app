
import 'package:flutter/cupertino.dart';
import 'package:newsapp/model/services/database_helper.dart';
import 'package:sqflite/sqlite_api.dart';

import '../model/model/user_model.dart';

class SignupViewModel extends ChangeNotifier{

  final DatabaseHelper databaseHelperInstance=DatabaseHelper.instance;

  Future<int?> signup(String fullName,String email,String password) async {

    Database? db = await databaseHelperInstance.database;
    return await db!.insert('user',User(fullName: fullName, email: email, password: password).toJson(),);

  }
  Future<bool?> emailExist(String email) async {

    Database? db = await databaseHelperInstance.database;
    var raw= await db!.query('user',where:'email = ? ',whereArgs: [email] );
    if(raw.isEmpty){
      return false;
    }else{
     return true;
    }

  }




}