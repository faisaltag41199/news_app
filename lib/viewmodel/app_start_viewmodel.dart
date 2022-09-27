
import 'package:flutter/cupertino.dart';

import '../main.dart';

class AppStartViewModel extends ChangeNotifier{

  String? setupCheck;



   checkSetupCategories()async{

    String? userId=  sharedpref!.getString('currentUser');
    int? appId= sharedpref!.getInt('appId');


    if(userId==null){

      String? setupCheckInside= sharedpref!.getString('setupCategories$appId');

      if(setupCheckInside!=null){


        setupCheck=setupCheckInside;
        notifyListeners();

      }else {
        setupCheck='false';
        notifyListeners();
      }

    }else{

      String? setupCheckInside=  sharedpref!.getString('setupCategories$userId');

      if(setupCheckInside!=null){

        setupCheck= setupCheckInside;
        notifyListeners();

      }else {
        setupCheck='false';
        notifyListeners();
      }


    }



  }

  setSetupCheckToNull(){
     setupCheck=null;
  }


}