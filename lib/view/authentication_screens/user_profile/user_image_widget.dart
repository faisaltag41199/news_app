import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/viewmodel/user_profile_model.dart';
import 'package:provider/provider.dart';

class UserImage extends StatelessWidget {
  const UserImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileViewModel>(
      builder: (context, userProfileVM, child) {
        if (userProfileVM.isDeleteImageRunning) {
          return Container(
            height: 100,
            width: 100,
            child: Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ))),
          );
        } else {
          if (userProfileVM.userProfileInfoWidgetdData['image'] == null ||
              userProfileVM.userProfileInfoWidgetdData['image'] ==
                  'undefined') {
            return TextButton(
                onPressed: () {
                  print('a7a hereeeeeeeeeeeeeeeeeeeeeeeee');

                  Provider.of<UserProfileViewModel>(context, listen: false)
                      .itemsUpdateStatus['image'] = 'start';
                  Provider.of<UserProfileViewModel>(context, listen: false)
                      .tabbedItemsStatus['image'] = 'edit';
                  print(
                      Provider.of<UserProfileViewModel>(context, listen: false)
                          .userProfileInfoWidgetdData['image']);

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => showImageScreen()));
                },
                child: FaIcon(
                  FontAwesomeIcons.circleUser,
                  size: 120,
                  color: Colors.black,
                ));
          } else {
            return TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 200,
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  print(
                                      'found hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
                                  Provider.of<UserProfileViewModel>(context,
                                          listen: false)
                                      .itemsUpdateStatus['image'] = 'start';
                                  Provider.of<UserProfileViewModel>(context,
                                          listen: false)
                                      .tabbedItemsStatus['image'] = 'edit';
                                  print(Provider.of<UserProfileViewModel>(
                                          context,
                                          listen: false)
                                      .userProfileInfoWidgetdData['image']);
                                  Navigator.of(context)
                                      .pop(); //close bottom sheet
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => showImageScreen()));
                                },
                                child: Text(
                                  'update image',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              TextButton(
                                onPressed: () {
                                  //close bottom sheet
                                  Provider.of<UserProfileViewModel>(context,
                                          listen: false)
                                      .changeIsDeleteImageRunning(true);
                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    Provider.of<UserProfileViewModel>(context,
                                            listen: false)
                                        .deleteImage();
                                  });
                                },
                                child: Text(
                                  'delete image',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'close',
                                    style: TextStyle(color: Colors.black),
                                  ))
                            ],
                          ),
                        );
                      });
                },
                child: File(userProfileVM.userProfileInfoWidgetdData['image'])
                            .existsSync() ==
                        true
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(
                            userProfileVM.userProfileInfoWidgetdData['image'])),
                      )
                    : FaIcon(
                        FontAwesomeIcons.circleUser,
                        size: 120,
                        color: Colors.black,
                      ));
          }
        }
      },
    );
  }
}

class showImageScreen extends StatefulWidget {
  const showImageScreen({Key? key}) : super(key: key);

  @override
  State<showImageScreen> createState() => _showImageScreenState();
}

class _showImageScreenState extends State<showImageScreen> {
  double height = 600;
  double width = 500;
  File? image;
  final imagePicker = ImagePicker();

  uploadImageFromGallery() async {
    var pickImage = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = File(pickImage!.path);
    });
  }

  uploadImageFromCamera() async {
    var pickImage = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      image = File(pickImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

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
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.1),
          child: Column(
            children: [
              image == null
                  ? Consumer<UserProfileViewModel>(
                      builder: (context, userProfileVM, child) {
                      if (userProfileVM.userProfileInfoWidgetdData['image'] ==
                              null ||
                          userProfileVM.userProfileInfoWidgetdData['image'] ==
                              'undefined') {
                        return Container(
                          padding: EdgeInsets.only(
                              top: height * 0.15, left: width * 0.07),
                          height: height * 0.65,
                          width: width * 0.85,
                          child: FaIcon(
                            FontAwesomeIcons.circleUser,
                            size: height * 0.35,
                          ),
                        );
                      } else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: height * 0.65,
                            width: width * 0.85,
                            child: File(userProfileVM
                                                .userProfileInfoWidgetdData[
                                            'image'])
                                        .existsSync() ==
                                    true
                                ? Image.file(
                                    File(userProfileVM
                                        .userProfileInfoWidgetdData['image']),
                                    fit: BoxFit.cover,
                                  )
                                : FaIcon(
                                    FontAwesomeIcons.circleUser,
                                    size: height * 0.35,
                                  ),
                          ),
                        );
                      }
                    })
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: height * 0.65,
                        width: width * 0.85,
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              Padding(padding: EdgeInsets.only(bottom: height * 0.05)),
              Row(
                children: [
                  Expanded(flex: 1, child: Text(' ')),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: uploadImageFromGallery,
                          icon: FaIcon(FontAwesomeIcons.image))),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: uploadImageFromCamera,
                          icon: FaIcon(FontAwesomeIcons.camera))),
                  Padding(padding: EdgeInsets.only(right: 15)),
                  Expanded(
                      flex: 6,
                      child: Consumer<UserProfileViewModel>(
                        builder: (context, userProfileVM, child) {
                          if (userProfileVM.tabbedItemsStatus['image'] ==
                              'edit') {
                            if (userProfileVM.itemsUpdateStatus['image'] ==
                                'done') {
                              Future.delayed(Duration(milliseconds: 300), () {
                                Navigator.of(context).pop();
                              });
                              return Container(
                                height: 50,
                                width: 50,
                                child: Scaffold(
                                    body: Center(
                                        child: CircularProgressIndicator(
                                  color: Colors.black,
                                ))),
                              );
                            } else {
                              return ElevatedButton(
                                onPressed: () {
                                  if (image != null) {
                                    userProfileVM.changeTabbedItemsStatus(
                                        "image", 'update');
                                    userProfileVM.updateImage(image!.path);
                                  } else {
                                    print(File(userProfileVM
                                                .userProfileInfoWidgetdData[
                                            'image'])
                                        .exists()
                                        .runtimeType);
                                  }
                                },
                                child: Text('Save'),
                                style: ElevatedButton.styleFrom(
                                    primary: image == null
                                        ? Colors.grey
                                        : Colors.black),
                              );
                            }
                          } else {
                            return Container(
                              height: 50,
                              width: 50,
                              child: Scaffold(
                                  body: Center(
                                      child: CircularProgressIndicator(
                                color: Colors.black,
                              ))),
                            );
                          }
                        },
                      )),
                  Expanded(flex: 1, child: Text(''))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
