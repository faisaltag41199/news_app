import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/view/category_screens/setup_app_categories.dart';
import 'package:newsapp/view/authentication_screens/login_view.dart';
import 'package:newsapp/viewmodel/Categories_viewmodel.dart';
import 'package:newsapp/viewmodel/login_viewmodel.dart';
import 'package:newsapp/viewmodel/signup_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/setup_category_viewmodel.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();

  late String _fullName, _email, _password;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();

  bool _showPassword = false;
  IconData _passwordSuffixIcon = FontAwesomeIcons.eyeSlash;
  FocusNode fullNameNode = FocusNode(),
      emailNode = FocusNode(),
      passwordNode = FocusNode();
  Color fullNameIconColor = Colors.grey;
  Color emailIconColor = Colors.grey;
  Color passwordIconColor = Colors.grey;
  Color passwordEyeIconColor = Colors.grey;
  double height = 5.0;
  double width = 5.0;

  @override
  void initState() {
    fullNameNode.addListener(() {
      setState(() {
        fullNameIconColor =
            fullNameIconColor == Colors.grey ? Colors.black : Colors.grey;
      });
    });

    emailNode.addListener(() {
      setState(() {
        emailIconColor =
            emailIconColor == Colors.grey ? Colors.black : Colors.grey;
      });
    });

    passwordNode.addListener(() {
      setState(() {
        passwordIconColor =
            passwordIconColor == Colors.grey ? Colors.black : Colors.grey;
        passwordEyeIconColor =
            passwordEyeIconColor == Colors.grey ? Colors.black : Colors.grey;
      });
    });
    super.initState();
  }

  String? validator(String? value, String textFieldName) {
    String emailReg =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    //String passwordReg=r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

    if (textFieldName == 'email') {
      if (value!.isEmpty || value == null) {
        return 'please enter your email';
      } else if (!RegExp(emailReg).hasMatch(value)) {
        return 'please enter valid email';
      } else {
        return null;
      }
    } else if (textFieldName == 'password') {
      if (value!.isEmpty || value == null) {
        return 'please enter your password';
      } else if (value.length < 6) {
        return 'password can not be less than 6 characters';
      } else {
        return null;
      }
    } else {
      if (value!.isEmpty || value == null) {
        return 'please enter full name';
      } else {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

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
            )),
      ),
      body: Container(
          child: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.only(left: width * 0.09),
          width: width * 0.8,
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.only(top: height * 0.15)),
              Text(
                'Hello there,',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Padding(padding: EdgeInsets.only(top: 6)),
              Text(
                'Create your new account',
                style: TextStyle(color: Colors.grey),
              ),
              Padding(padding: EdgeInsets.all(20)),
              TextFormField(
                focusNode: fullNameNode,
                validator: (String? input) => validator(input, 'fullName'),
                enableInteractiveSelection: true,
                autofillHints: [AutofillHints.name],
                enableSuggestions: true,
                autocorrect: true,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 11, left: 9),
                      child: FaIcon(FontAwesomeIcons.user,
                          size: 22, color: fullNameIconColor),
                    ),
                    labelStyle: const TextStyle(color: Colors.grey),
                    label: const Text('fullname'),
                    fillColor: Colors.black,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
                onChanged: (value) {
                  _fullName = value;
                },
              ),
              Padding(padding: EdgeInsets.all(13)),
              TextFormField(
                focusNode: emailNode,
                validator: (String? input) => validator(input, 'email'),
                enableInteractiveSelection: true,
                autofillHints: [AutofillHints.email],
                enableSuggestions: true,
                autocorrect: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 11, left: 9),
                      child: FaIcon(FontAwesomeIcons.envelope,
                          size: 22, color: emailIconColor),
                    ),
                    labelStyle: const TextStyle(color: Colors.grey),
                    label: const Text('email'),
                    fillColor: Colors.black,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
                onChanged: (value) {
                  _email = value;
                },
              ),
              Padding(padding: EdgeInsets.all(13)),
              TextFormField(
                focusNode: passwordNode,
                validator: (String? input) => validator(input, 'password'),
                obscureText: !_showPassword,
                enableSuggestions: false,
                autocorrect: false,
                toolbarOptions: ToolbarOptions(selectAll: true, paste: true),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(top: 11, left: 12),
                    child: FaIcon(FontAwesomeIcons.lock,
                        size: 20, color: passwordIconColor),
                  ),
                  labelStyle: TextStyle(color: Colors.grey),
                  label: Text('password'),
                  fillColor: Colors.black,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                        _passwordSuffixIcon =
                            _passwordSuffixIcon == FontAwesomeIcons.eyeSlash
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash;
                      });
                    },
                    icon: FaIcon(_passwordSuffixIcon,
                        size: 18, color: passwordEyeIconColor),
                  ),
                ),
                onChanged: (value) {
                  _password = value;
                },
              ),
              Padding(padding: EdgeInsets.all(30)),
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _showMyDialog();
                      print(_formKey.currentState!.validate());
                      print(_fullName);
                      print(_email);
                      print(_password);

                      await Provider.of<SignupViewModel>(context, listen: false)
                          .emailExist(_email)
                          .then((value) async {
                        if (value!) {
                          Navigator.of(context).pop();
                          SnackBar snakbar = SnackBar(
                            content: Text(
                              'email already exist please login.',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.black,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snakbar);
                        } else {
                          await Provider.of<SignupViewModel>(context,
                                  listen: false)
                              .signup(_fullName, _email, _password)
                              .then((value) {
                            print(value);
                            Provider.of<SetupCategoriesViewModel>(context,
                                    listen: false)
                                .setAllSetupCategoriesMembersToEmpty();
                            Provider.of<LoginViewModel>(context, listen: false)
                                .setIsLogged(true);

                            sharedpref!
                                .setString('currentUser', value!.toString());
                            Future.delayed(Duration(milliseconds: 200), () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SetupAppCategories()),
                                  (route) => false);
                            });
                          });
                        }
                      });
                    }
                  },
                  child: const Text('Sign up'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),

              /* Padding(padding: EdgeInsets.only(top: height*0.2)),

            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Text('Dont have an account ? ') , TextButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignupView()));
              }, child: Text('Sign Up',style: TextStyle(color:Colors.black)))
            ],)*/
            ],
          ),
        ),
      )),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('singing up',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          content: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                      height: 100,
                      width: 100,
                      child: Scaffold(
                        backgroundColor: Colors.white,
                        body: Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 20),
                    child: Text("please wait ......",
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
