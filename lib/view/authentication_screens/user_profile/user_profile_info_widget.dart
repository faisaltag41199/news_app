import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/user_profile_model.dart';

class UserProfileInfoWidget extends StatelessWidget {
  UserProfileInfoWidget({required this.name});

  String name;
  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Consumer<UserProfileViewModel>(
      builder: (context, userProfileVM, child) {
        print('//////////////////////////////////////////////////////////////');
        print(userProfileVM.tabbedItemsStatus.containsKey(name));

        if (userProfileVM.tabbedItemsStatus.containsKey(name) == false) {
          userProfileVM.tabbedItemsStatus[name] = 'edit';
        }

        if (userProfileVM.tabbedItemsStatus[name] == 'edit') {
          Future.delayed(Duration(milliseconds: 200), () {
            if (userProfileVM.itemsUpdateStatus.containsKey(name)) {
              if (userProfileVM.itemsUpdateStatus[name] == 'done') {
                print(userProfileVM.itemsUpdateStatus[name]);
                SnackBar snackBar =
                    SnackBar(content: Text('$name Update Completed'));

                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                userProfileVM.itemsUpdateStatus[name] = 'start';
              }
            }
          });

          return Row(
            children: [
              InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: height * 0.04)),
                    name == 'fullName'
                        ? Text(
                            'full name',
                            style: TextStyle(color: Colors.grey),
                          )
                        : Text(
                            name,
                            style: TextStyle(color: Colors.grey),
                          ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    name == 'password'
                        ? Text("**********",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18))
                        : Text(userProfileVM.userProfileInfoWidgetdData[name],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18))
                  ],
                ),
                onTap: () {
                  userProfileVM.changeTabbedItemsStatus(name, 'update');
                },
              ),
              Expanded(child: Text(' ')),
              ElevatedButton(
                onPressed: () {
                  userProfileVM.changeTabbedItemsStatus(name, 'update');
                },
                child: const Text('Edit'),
                style: ElevatedButton.styleFrom(primary: Colors.black),
              )
            ],
          );
        } else {
          if (name == 'fullName') {
            return FullNameCustomTextField();
          } else if (name == 'email') {
            return EmailCustomTextField();
          } else {
            return PasswordCustomTextField();
          }
        }
      },
    );
  }
}

//email textfield
class EmailCustomTextField extends StatefulWidget {
  const EmailCustomTextField({Key? key}) : super(key: key);

  @override
  State<EmailCustomTextField> createState() => _EmailCustomTextFieldState();
}

class _EmailCustomTextFieldState extends State<EmailCustomTextField> {
  String? _email;
  String? _validate;

  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Consumer<UserProfileViewModel>(
        builder: (context, userProfileVM, child) {
      return Row(
        children: [
          Column(
            children: [
              Text('email'),
              Container(
                width: width * 0.7,
                child: TextField(
                  enableSuggestions: true,
                  enableInteractiveSelection: true,
                  autocorrect: true,
                  autofillHints: [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 11, left: 9),
                      child: FaIcon(FontAwesomeIcons.envelope,
                          size: 22, color: Colors.black),
                    ),
                    errorText: _validate,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  onChanged: (value) {
                    _email = value;
                  },
                ),
              )
            ],
          ),
          userProfileVM.tabbedItemsStatus['email'] == 'update'
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.014),
                      child: ElevatedButton(
                        onPressed: () {
                          String emailReg =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                          if (_email == null) {
                            setState(() {
                              _validate = "email can't be empty";
                            });
                          } else if (_email!.isEmpty) {
                            setState(() {
                              _validate = "email can't be empty";
                            });
                          } else if (!RegExp(emailReg).hasMatch(_email!)) {
                            setState(() {
                              _validate = "please enter valid email";
                            });
                          } else {
                            userProfileVM.itemsUpdateStatus['email'] = 'start';
                            userProfileVM.changeTabbedItemsStatus(
                                'email', 'loading');
                            Future.delayed(Duration(milliseconds: 200), () {
                              userProfileVM.updateEmail(_email!);
                            });
                          }
                        },
                        child: const Text('update'),
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        userProfileVM.changeTabbedItemsStatus('email', 'edit');
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                    )
                  ],
                )
              : Container(
                  height: 50,
                  width: 50,
                  child: Scaffold(
                      body: Center(
                          child: CircularProgressIndicator(
                    color: Colors.black,
                  ))),
                )
        ],
      );
    });
  }
}

//fullName textfield

class FullNameCustomTextField extends StatefulWidget {
  const FullNameCustomTextField({Key? key}) : super(key: key);

  @override
  State<FullNameCustomTextField> createState() =>
      _FullNameCustomTextFieldState();
}

class _FullNameCustomTextFieldState extends State<FullNameCustomTextField> {
  String? _fullName;
  String? _validate;

  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Consumer<UserProfileViewModel>(
        builder: (context, userProfileVM, child) {
      return Row(
        children: [
          Column(
            children: [
              Text('fullName'),
              Container(
                width: width * 0.7,
                child: TextField(
                  enableSuggestions: true,
                  enableInteractiveSelection: true,
                  autocorrect: true,
                  autofillHints: [AutofillHints.name],
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 11, left: 9),
                      child: FaIcon(FontAwesomeIcons.user,
                          size: 22, color: Colors.black),
                    ),
                    errorText: _validate,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  onChanged: (value) {
                    _fullName = value;
                  },
                ),
              )
            ],
          ),
          userProfileVM.tabbedItemsStatus['fullName'] == 'update'
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.014),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_fullName == null) {
                            setState(() {
                              _validate = "fullname can't be empty";
                            });
                          } else if (_fullName!.isEmpty) {
                            setState(() {
                              _validate = "fullname can't be empty";
                            });
                          } else {
                            userProfileVM.itemsUpdateStatus['fullName'] =
                                'start';
                            userProfileVM.changeTabbedItemsStatus(
                                'fullName', 'loading');
                            Future.delayed(Duration(milliseconds: 200), () {
                              userProfileVM.updateFullName(_fullName!);
                            });
                          }
                        },
                        child: const Text('update'),
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        userProfileVM.changeTabbedItemsStatus(
                            'fullName', 'edit');
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                    )
                  ],
                )
              : Container(
                  height: 50,
                  width: 50,
                  child: Scaffold(
                      body: Center(
                          child: CircularProgressIndicator(
                    color: Colors.black,
                  ))),
                )
        ],
      );
    });
  }
}

//password textfield

class PasswordCustomTextField extends StatefulWidget {
  const PasswordCustomTextField({Key? key}) : super(key: key);

  @override
  State<PasswordCustomTextField> createState() =>
      _PasswordCustomTextFieldState();
}

class _PasswordCustomTextFieldState extends State<PasswordCustomTextField> {
  String? _password;
  String? _validate;
  bool _isobscureText = true;
  IconData _passwordSuffixIcon = FontAwesomeIcons.eyeSlash;

  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Consumer<UserProfileViewModel>(
        builder: (context, userProfileVM, child) {
      return Row(
        children: [
          Column(
            children: [
              Text('password'),
              Container(
                width: width * 0.7,
                child: TextField(
                  obscureText: _isobscureText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isobscureText = !_isobscureText;
                          _passwordSuffixIcon =
                              _passwordSuffixIcon == FontAwesomeIcons.eyeSlash
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash;
                        });
                      },
                      icon: FaIcon(_passwordSuffixIcon,
                          size: 18, color: Colors.black),
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(top: 11, left: 9),
                      child: FaIcon(FontAwesomeIcons.user,
                          size: 22, color: Colors.black),
                    ),
                    errorText: _validate,
                    fillColor: Colors.black,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  onChanged: (value) {
                    _password = value;
                  },
                ),
              )
            ],
          ),
          userProfileVM.tabbedItemsStatus['password'] == 'update'
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.014),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_password == null) {
                            setState(() {
                              _validate = "password can't be empty";
                            });
                          } else if (_password!.isEmpty) {
                            setState(() {
                              _validate = "password can't be empty";
                            });
                          } else if (_password!.length < 6) {
                            _validate =
                                'password can not be less than 6 characters';
                          } else {
                            userProfileVM.itemsUpdateStatus['password'] =
                                'start';
                            userProfileVM.changeTabbedItemsStatus(
                                'password', 'loading');
                            Future.delayed(Duration(milliseconds: 200), () {
                              userProfileVM.updatePassword(_password!);
                            });
                          }
                        },
                        child: const Text('update'),
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        userProfileVM.changeTabbedItemsStatus(
                            'password', 'edit');
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                    )
                  ],
                )
              : Container(
                  height: 50,
                  width: 50,
                  child: Scaffold(
                      body: Center(
                          child: CircularProgressIndicator(
                    color: Colors.black,
                  ))),
                )
        ],
      );
    });
  }
}
