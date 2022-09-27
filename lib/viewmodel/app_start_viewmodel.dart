
import 'package:flutter/cupertino.dart';

import '../main.dart';

class AppStartViewModel extends ChangeNotifier{

  String? setupCheck=null;



   checkSetupCategories()async{

    String? userId= sharedpref!.getString('currentUser');
    int? appId= sharedpref!.getInt('appId');


    if(userId==null){

      String? setupCheckInside= sharedpref!.getString('setupCategories$appId');
      print(setupCheckInside);
      print("setupCheckInside app ///////////////////////");


      if(setupCheckInside!=null){


        setupCheck=setupCheckInside;
        notifyListeners();

      }else {
        setupCheck='false';
        notifyListeners();
      }

    }else{


      String? setupCheckInside = sharedpref!.getString('setupCategories$userId');
      print(setupCheckInside);
      print("setupCheckInside user ///////////////////////");


      if(setupCheckInside!=null){

        setupCheck= setupCheckInside;
        notifyListeners();

      }else {
        setupCheck='false';
        notifyListeners();
      }


    }



  }


}