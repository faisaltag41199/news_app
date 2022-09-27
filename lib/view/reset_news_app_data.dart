import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/viewmodel/app_start_viewmodel.dart';
import 'package:newsapp/viewmodel/user_profile_model.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import '../model/services/database_helper.dart';
import 'app_start.dart';
import 'loading_animations.dart';

class ResetNewsAppData extends StatefulWidget {
  const ResetNewsAppData({Key? key}) : super(key: key);

  @override
  State<ResetNewsAppData> createState() => _ResetNewsAppDataState();
}

class _ResetNewsAppDataState extends State<ResetNewsAppData> {
  bool showCircular = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: showCircular
              ? CircularProgressIndicator(
                  color: Colors.red,
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () async {
                    await databaseFactory
                        .deleteDatabase(
                            join(await getDatabasesPath(), 'newsapp.db'))
                        .whenComplete(() async {
                      String? userId = sharedpref!.getString('currentUser');
                      int? appId = sharedpref!.getInt('appId');

                      /*    await sharedpref!.remove('setupCategories$appId');
                    await sharedpref!.remove('setupCategories$userId');
                    await sharedpref!.remove('currentUser');
                    await sharedpref!.remove('appId');*/
                      await sharedpref!.clear().whenComplete(() {
                        Provider.of<AppStartViewModel>(context, listen: false)
                            .setSetupCheckToNull();
                        DatabaseHelper instance = DatabaseHelper.instance;
                        instance.setDatabaseToNull();
                        setState(() {
                          showCircular = true;
                        });

                        Future.delayed(Duration(milliseconds: 300), () {
                          print('database deleted');
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppStart()),
                              (route) => false);
                        });
                      });
                    });
                  },
                  child: Text('Delete All Data')),
        ));
  }
}
