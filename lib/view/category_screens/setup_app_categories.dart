import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/view/category_screens/category_View_IconButton.dart';
import 'package:newsapp/view/app_start.dart';
import 'package:newsapp/view/category_screens/setup_category_iconbutton.dart';
import 'package:newsapp/view/main_screens/home_view.dart';
import 'package:newsapp/view/main_screens_start.dart';
import 'package:newsapp/viewmodel/Categories_viewmodel.dart';
import 'package:newsapp/viewmodel/setup_category_viewmodel.dart';
import 'package:newsapp/viewmodel/user_profile_model.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../main.dart';
import '../../model/services/database_helper.dart';

class SetupAppCategories extends StatefulWidget {
  const SetupAppCategories({Key? key}) : super(key: key);

  @override
  State<SetupAppCategories> createState() => _SetupAppCategoriesState();
}

class _SetupAppCategoriesState extends State<SetupAppCategories> {
  double height = 0.0;
  double width = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Follow Categories',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Consumer<SetupCategoriesViewModel>(
        builder: (context, setupCategoriesViewModel, child) {
          if (setupCategoriesViewModel.setupComplete >=
                  setupCategoriesViewModel.listOfSetupCategoris.length &&
              setupCategoriesViewModel.setupComplete >= 1) {
            print('setupcategories to homeStarter');
            Provider.of<CategoriesViewModel>(context, listen: false)
                .fetchCategoriesList();

            return Consumer<CategoriesViewModel>(
                builder: (context, categoriesViewModel, child) {
              if (categoriesViewModel.tabBarControllerLength >=
                      (categoriesViewModel.idsList.length) + 1 &&
                  categoriesViewModel.idsList.length >= 1) {
                print(
                    'in home starter  tabcontroller lenth ${categoriesViewModel.tabBarControllerLength}');

                Provider.of<UserProfileViewModel>(context, listen: false)
                    .fetchUserData();

                Future.delayed(const Duration(milliseconds: 500), () {
                  print('in future.dely starter ');

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainStart()),
                      (route) => false);
                });
              }

              return Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ));
            });
          }

          print('${setupCategoriesViewModel.setupComplete} from setupappview');
          return Padding(
            padding: EdgeInsets.only(top: height * 0.15),
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(flex: 1, child: Text('    ')),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            SetupCategoryIconButton(
                                id: '2',
                                name: 'entertainment',
                                icon: FontAwesomeIcons.clapperboard),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'entertainment',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            SetupCategoryIconButton(
                                id: '3',
                                name: 'sports',
                                icon: FontAwesomeIcons.basketball),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'sports',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            SetupCategoryIconButton(
                                id: '4',
                                name: 'technology',
                                icon: FontAwesomeIcons.microchip),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'technology',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Expanded(flex: 1, child: Text('    ')),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(height * 0.03)),
                  Row(
                    children: [
                      const Expanded(flex: 1, child: Text('    ')),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            SetupCategoryIconButton(
                              id: '5',
                              name: 'business',
                              icon: FontAwesomeIcons.chartLine,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'business',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            SetupCategoryIconButton(
                                id: '6',
                                name: 'science',
                                icon: FontAwesomeIcons.atom),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'science',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            SetupCategoryIconButton(
                              id: '7',
                              name: 'health',
                              icon: FontAwesomeIcons.briefcaseMedical,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'health',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Expanded(flex: 1, child: Text('    '))
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(height * 0.03)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.all(width * 0.062)),
                      Column(
                        children: [
                          SetupCategoryIconButton(
                            id: '8',
                            name: 'general',
                            icon: FontAwesomeIcons.earthAfrica,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'general',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(height * 0.04)),
                  SizedBox(
                    height: 55,
                    width: width * 0.8,
                    child: ElevatedButton(
                      onPressed: () async {
                        print(
                            '${sharedpref!.getInt('appId')} in elevated button app id is found');

                        String? userId =
                            await sharedpref!.getString('currentUser');
                        int? appId = await sharedpref!.getInt('appId');

                        print('in elvated button');
                        if (setupCategoriesViewModel.numOfFollowedCategories >=
                            3) {
                          print('in elvated button in continue');

                          if (userId == null) {
                            //from getstarted and use app Id
                            print(' in elvated button in savesetupCategories');
                            if (appId != null) {
                              sharedpref!
                                  .setString('setupCategories$appId', 'true');
                              setupCategoriesViewModel
                                  .saveAppSetupCategories(appId);
                            } else {
                              DatabaseHelper instance = DatabaseHelper.instance;
                              Database? db = await instance.database;
                              List raw = await db!.query('user',
                                  where: "email = ?",
                                  whereArgs: ['newsapp@news.com']);
                              Map appAsUserData = raw[0];
                              sharedpref!
                                  .setInt('appId', appAsUserData['userId']);
                              print(appAsUserData['userId']);
                              sharedpref!
                                  .setString(
                                      'setupCategories${appAsUserData['userId']}',
                                      'true')
                                  .whenComplete(() {
                                setupCategoriesViewModel.saveAppSetupCategories(
                                    appAsUserData['userId']);
                              });
                            }
                          } else {
                            //after signup getstarted

                            sharedpref!
                                .setString('setupCategories$userId', 'true');
                            setupCategoriesViewModel
                                .saveUserSetupCategories(int.parse(userId));
                          }
                        }
                      },
                      child: setupCategoriesViewModel.numOfFollowedCategories >=
                              3
                          ? Text('continue')
                          : Text(
                              '${setupCategoriesViewModel.numOfFollowedCategories >= 1 ? "still" : "choose"} '
                              '${3 - setupCategoriesViewModel.numOfFollowedCategories} to go'),
                      style: ElevatedButton.styleFrom(
                        primary:
                            setupCategoriesViewModel.numOfFollowedCategories >=
                                    3
                                ? Colors.black
                                : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
