import 'dart:convert';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/view/app_start.dart';
import 'package:newsapp/view/authentication_screens/login_view.dart';
import 'package:newsapp/view/category_screens/user_category_view.dart';
import 'package:newsapp/view/main_screens_start.dart';
import 'package:newsapp/view/reset_news_app_data.dart';
import 'package:newsapp/viewmodel/Categories_viewmodel.dart';
import 'package:newsapp/viewmodel/app_start_viewmodel.dart';
import 'package:newsapp/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/user_profile_model.dart';
import '../authentication_screens/user_profile/user_profile.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  double height = 5;
  double width = 5;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(top: height * 0.028),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: height,
          width: width,
          margin: EdgeInsets.only(top: 0.01),
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 10),
                    child: Text(
                      "Account",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Consumer<LoginViewModel>(builder: (context, loginVM, child) {
                    if (loginVM.isLogged == false) {
                      return Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                              child: ListTile(
                                leading: const FaIcon(
                                  FontAwesomeIcons.circleUser,
                                  color: Colors.black,
                                ),
                                title: Text('Login'),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginView()));
                              }));
                    } else {
                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                Provider.of<UserProfileViewModel>(context,
                                        listen: false)
                                    .tabbedItemsStatus
                                    .forEach((key, value) {
                                  Provider.of<UserProfileViewModel>(context,
                                          listen: false)
                                      .tabbedItemsStatus[key] = 'edit';
                                });

                                Future.delayed(Duration(milliseconds: 250), () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UserProfile()));
                                });
                              },
                              child: ListTile(
                                leading: (Provider.of<UserProfileViewModel>(
                                                    context)
                                                .user
                                                .imageUrl ==
                                            'undefined' ||
                                        Provider.of<UserProfileViewModel>(
                                                    context)
                                                .user
                                                .imageUrl ==
                                            null)
                                    ? CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 25,
                                        child: FaIcon(
                                          FontAwesomeIcons.circleUser,
                                          color: Colors.black,
                                          size: 46,
                                        ),
                                      )
                                    /*FaIcon(FontAwesomeIcons.circleUser)*/ : File(
                                                    (Provider.of<
                                                                UserProfileViewModel>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .imageUrl)!)
                                                .existsSync() ==
                                            true
                                        ? CircleAvatar(
                                            radius: 25,
                                            backgroundImage: FileImage(File(
                                                (Provider.of<
                                                            UserProfileViewModel>(
                                                        context,
                                                        listen: false)
                                                    .user
                                                    .imageUrl)!)),
                                          )
                                        : CircleAvatar(
                                            radius: 25,
                                            child: FaIcon(
                                                FontAwesomeIcons.circleUser),
                                          ),
                                title: Text(
                                    Provider.of<UserProfileViewModel>(context)
                                        .user
                                        .fullName),
                                subtitle: Text(
                                    Provider.of<UserProfileViewModel>(context)
                                        .user
                                        .email),
                                trailing: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Edit',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          color: Colors.black)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(color: Colors.black54),
                            TextButton(
                                child: ListTile(
                                  leading: FaIcon(
                                    FontAwesomeIcons.powerOff,
                                    color: Colors.black,
                                  ),
                                  title: Text('Logout'),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      color: Colors.black),
                                ),
                                onPressed: () {
                                  Provider.of<AppStartViewModel>(context,listen: false).setupCheck=null;
                                  loginVM.logout();
                                  Future.delayed(Duration(milliseconds: 300),
                                      () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => AppStart()),
                                        (route) => false);
                                  });
                                }),
                          ],
                        ),
                      );
                    }
                  }),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 10),
                    child: Text(
                      "General",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        TextButton(
                          child: ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.list,
                              color: Colors.black,
                            ),
                            title: Text('Categories'),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.black),
                          ),
                          onPressed: () {
                            Provider.of<CategoriesViewModel>(context,
                                    listen: false)
                                .setnewCategoriesListToEmpty();
                            Provider.of<CategoriesViewModel>(context,
                                    listen: false)
                                .setremovedCategoriesListToEmpty();
                            Provider.of<CategoriesViewModel>(context,
                                    listen: false)
                                .saveCategoriesComplete = 0;
                            Provider.of<CategoriesViewModel>(context,
                                    listen: false)
                                .afterSaveNewCategories = false;
                            Provider.of<CategoriesViewModel>(context,
                                    listen: false)
                                .removeCategoriesOnlyComplete = 0;
                            Provider.of<CategoriesViewModel>(context,
                                    listen: false)
                                .afterRemoveOnlyCategories = false;

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserCategoryView()));
                          },
                        ),
                        Divider(color: Colors.black54),
                        TextButton(
                          child: ListTile(
                            leading: FaIcon(FontAwesomeIcons.globe,
                                color: Colors.black),
                            title: Text('Article Country'),
                            subtitle: sharedpref!.getString('country') == null
                                ? Text('egypt')
                                : Text((sharedpref!.getString('country'))!),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.black),
                          ),
                          onPressed: () {
                            showCountryPicker(
                              countryListTheme: CountryListThemeData(
                                  inputDecoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      labelText: 'Search',
                                      hintText: 'Start typing to search',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                              color: Colors.black)))),
                              context: context,
                              showPhoneCode: false,
                              // optional. Shows phone code before the country name.
                              onSelect: (Country country) {
                                print(
                                    'Select country////////////////////////////////////|||||||||||: ${country.countryCode.toLowerCase()}');
                                print(
                                    'Select countrycode////////////////////////////////||||||||||||: ${country.displayName.toLowerCase()}');

                                sharedpref!.setString(
                                    'country',
                                    country.displayName
                                        .toLowerCase()
                                        .split(' (')[0]);
                                sharedpref!
                                    .setString('countryCode',
                                        country.countryCode.toLowerCase())
                                    .whenComplete(() {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainStart()),
                                      (route) => false);
                                });
                              },
                            );
                          },
                        ),
                        Divider(color: Colors.black54),
                        TextButton(
                            child: ListTile(
                              leading: FaIcon(
                                FontAwesomeIcons.gears,
                                color: Colors.black,
                              ),
                              title: Text('Clear Data'),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ResetNewsAppData()));
                            })
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
