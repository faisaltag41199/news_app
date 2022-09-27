import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/view/category_screens/category_View_IconButton.dart';
import 'package:newsapp/view/app_start.dart';
import 'package:newsapp/view/main_screens_start.dart';
import 'package:newsapp/viewmodel/Categories_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class UserCategoryView extends StatefulWidget {
  const UserCategoryView({Key? key}) : super(key: key);

  @override
  State<UserCategoryView> createState() => _UserCategoryViewState();
}

class _UserCategoryViewState extends State<UserCategoryView> {
  double height = 0.0;
  double width = 0.0;

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
          'Followed Categories',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<CategoriesViewModel>(
        builder: (context, categoriesViewModel, child) {
          //as the consumer rebuild if any change occure

          print(
              "${categoriesViewModel.saveCategoriesComplete} categoriesViewModel.saveCategoriesComplete ");
          print(
              "${categoriesViewModel.newCategoriesList.length} categoriesViewModel.newCategoriesList.length ");
          print(
              "${categoriesViewModel.removeCategoriesOnlyComplete} categoriesViewModel.removeCategoriesOnlyComplete ");

          // condition if data new categories saved or not or categories removed only ;
          if (((categoriesViewModel.saveCategoriesComplete >=
                      categoriesViewModel.newCategoriesList.length) &&
                  (categoriesViewModel.saveCategoriesComplete >= 1)) ||
              ((categoriesViewModel.removeCategoriesOnlyComplete >=
                      categoriesViewModel.removedCategoriesList.length) &&
                  (categoriesViewModel.removeCategoriesOnlyComplete >= 1))) {
            //fetch one time after save new categories or remove only categories
            if (categoriesViewModel.afterSaveNewCategories ||
                categoriesViewModel.afterRemoveOnlyCategories) {
              print(
                  "${categoriesViewModel.afterSaveNewCategories} categoriesViewModel.afterSaveNewCategories ");
              print(
                  "${categoriesViewModel.afterRemoveOnlyCategories} categoriesViewModel.afterRemoveOnlyCategories ");

              categoriesViewModel.afterSaveNewCategories = false;
              categoriesViewModel.afterRemoveOnlyCategories = false;
              categoriesViewModel.fetchCategoriesList();
            }

            //condition if the data fetched or not yet
            if ((categoriesViewModel.tabBarControllerLength >=
                    categoriesViewModel.idsList.length + 1) &&
                (categoriesViewModel.idsList.length >= 1)) {
              print(
                  "${categoriesViewModel.tabBarControllerLength} categoriesViewModel.tabBarControllerLength ");
              print(
                  'in push to mainstart from save categories usercategory view ');

              Future.delayed(const Duration(milliseconds: 500), () {
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
          }

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
                            CategoryViewIconButton(
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
                            CategoryViewIconButton(
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
                            CategoryViewIconButton(
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
                            CategoryViewIconButton(
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
                            CategoryViewIconButton(
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
                            CategoryViewIconButton(
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
                          CategoryViewIconButton(
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
                    height: 40,
                    width: width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        int categoListLength =
                            categoriesViewModel.categoriesList.length;
                        int removedCategoListLength =
                            categoriesViewModel.removedCategoriesList.length;
                        int newCategoListlength =
                            categoriesViewModel.newCategoriesList.length;

                        print(categoriesViewModel.categoriesList);
                        print(categoriesViewModel.removedCategoriesList);
                        print(categoriesViewModel.newCategoriesList);

                        if (((categoListLength - removedCategoListLength) +
                                    newCategoListlength) >=
                                3 &&
                            newCategoListlength >= 1) {
                          print('${sharedpref!.getInt('appId')} appId');

                          String? userId = sharedpref!.getString('currentUser');
                          int? appId = sharedpref!.getInt('appId');

                          if (userId == null) {
                            //from getstarted and use app Id
                            print(' in elvated button in saveCategories');
                            if (appId != null) {
                              categoriesViewModel.saveAppCategoriesList(appId);
                            } else {
                              print(
                                  ' in elvated button in saveCategories appid not found');
                            }
                          } else {
                            //after signup getstarted
                            categoriesViewModel
                                .saveUserCategoriesList(int.parse(userId));
                          }
                        } else if (((categoListLength -
                                        removedCategoListLength) +
                                    newCategoListlength) >=
                                3 &&
                            removedCategoListLength >= 1) {
                          print('${sharedpref!.getInt('appId')} appId');

                          String? userId = sharedpref!.getString('currentUser');
                          int? appId = sharedpref!.getInt('appId');

                          if (userId == null) {
                            //from getstarted and use app Id
                            print(' in elvated button in saveCategories');
                            if (appId != null) {
                              categoriesViewModel
                                  .removeAppCategoriesList(appId);
                            } else {
                              print(
                                  ' in elvated button in saveCategories appid not found');
                            }
                          } else {
                            //after signup getstarted
                            categoriesViewModel
                                .removeUserCategoriesList(int.parse(userId));
                          }
                        }
                      },
                      child: ((categoriesViewModel.categoriesList.length) -
                                      (categoriesViewModel
                                          .removedCategoriesList.length)) +
                                  (categoriesViewModel
                                      .newCategoriesList.length) >=
                              3
                          ? Text('save')
                          : Text(((categoriesViewModel.categoriesList.length) -
                                          (categoriesViewModel
                                              .removedCategoriesList.length)) +
                                      (categoriesViewModel
                                          .newCategoriesList.length) ==
                                  0
                              ? 'choose 3 to save'
                              : "still ${3 - (((categoriesViewModel.categoriesList.length) - (categoriesViewModel.removedCategoriesList.length)) + (categoriesViewModel.newCategoriesList.length))} to save"),
                      style: ElevatedButton.styleFrom(
                        primary: ((categoriesViewModel.categoriesList.length) -
                                        (categoriesViewModel
                                            .removedCategoriesList.length)) +
                                    (categoriesViewModel
                                        .newCategoriesList.length) >=
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
