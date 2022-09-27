import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/view/app_start.dart';
import 'package:newsapp/view/authentication_screens/user_profile/user_image_widget.dart';
import 'package:newsapp/view/authentication_screens/user_profile/user_profile_info_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late double height;
  late double width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.only(
            top: height * 0.08, left: width * 0.04, right: width * 0.04),
        width: width,
        height: height,
        child: ListView(
          shrinkWrap: true,
          children: [
            UserImage(),
            Padding(padding: EdgeInsets.only(top: height * 0.1)),
            Container(
                height: height * 0.13,
                width: width,
                child: UserProfileInfoWidget(name: 'fullName')),
            Padding(padding: EdgeInsets.only(top: height * 0.03)),
            Container(
                height: height * 0.13,
                width: width,
                child: UserProfileInfoWidget(name: 'email')),
            Padding(padding: EdgeInsets.only(top: height * 0.03)),
            Container(
                height: height * 0.13,
                width: width,
                child: UserProfileInfoWidget(name: 'password')),
          ],
        ),
      ),
    );
  }
}
