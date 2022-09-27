import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/model/services/database_helper.dart';
import 'package:newsapp/view/main_screens/home_view.dart';
import 'package:newsapp/view/main_screens_start.dart';
import 'package:newsapp/view/authentication_screens/signup_view.dart';
import 'package:newsapp/viewmodel/Categories_viewmodel.dart';
import 'package:newsapp/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../app_start.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  IconData _passwordSuffixIcon = FontAwesomeIcons.eyeSlash;
  FocusNode emailNode = FocusNode(), passwordNode = FocusNode();
  Color emailIconColor = Colors.grey;
  Color passwordIconColor = Colors.grey;
  Color passwordEyeIconColor = Colors.grey;
  double height = 5.0;
  double width = 5.0;

  @override
  void initState() {
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
    } else {
      if (value!.isEmpty || value == null) {
        return 'please enter your password';
      } else if (value.length < 6) {
        return 'password can not be less than 6 characters';
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
      body: Container(
          child: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.only(left: width * 0.09),
          width: width * 0.8,
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.only(top: height * 0.2)),
              Text(
                'Hello there,',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Padding(padding: EdgeInsets.only(top: 6)),
              Text(
                'Login to your account',
                style: TextStyle(color: Colors.grey),
              ),
              Padding(padding: EdgeInsets.all(20)),
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
              Padding(padding: EdgeInsets.all(13)),
              Padding(
                padding: EdgeInsets.only(right: width * 0.5),
                child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forget Password ?',
                      style: TextStyle(color: Colors.black),
                    )),
              ),
              Padding(padding: EdgeInsets.all(13)),
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _showMyDialog();
                      print(_formKey.currentState!.validate());
                      print(_email);
                      print('///////////////////////////////');

                      await Provider.of<LoginViewModel>(context, listen: false)
                          .login(_email, _password)
                          .then((value) async {
                        if (value == 'email not found') {
                          Navigator.of(context).pop();
                          SnackBar snakbar = SnackBar(
                            content: Text(
                              value!,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.black,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snakbar);
                        } else if (value == 'password invalid') {
                          Navigator.of(context).pop();
                          SnackBar snakbar = SnackBar(
                            content: Text(
                              value!,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.black,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snakbar);
                        } else {
                          Database? db = await DatabaseHelper.instance.database;
                          await db!.query('user',
                              where: 'email = ? ',
                              whereArgs: [_email]).then((raw) async {
                            Map userdata = raw[0];
                            sharedpref!
                                .setString('currentUser',
                                    userdata['userId'].toString())
                                .whenComplete(() {
                              Provider.of<LoginViewModel>(context,
                                      listen: false)
                                  .setIsLogged(true);

                              Future.delayed(const Duration(milliseconds: 200),
                                  () {
                                print(
                                    'in future.dely to appstart from loginview ');

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AppStart()),
                                    (route) => false);
                              });
                            });
                          });
                        }
                      });
                    }
                  },
                  child: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: height * 0.2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dont have an account ? '),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignupView()));
                      },
                      child: Text('Sign Up',
                          style: TextStyle(color: Colors.black)))
                ],
              )
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
          title: const Text('Loging in',
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
