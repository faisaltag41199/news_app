import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/model/model/category_model.dart';
import 'package:newsapp/viewmodel/setup_category_viewmodel.dart';
import 'package:provider/provider.dart';

class SetupCategoryIconButton extends StatefulWidget {
  String name;
  String id;
  IconData icon;
  bool clicked = false;

  SetupCategoryIconButton(
      {Key? key, required this.name, required this.id, required this.icon})
      : super(key: key);

  @override
  State<SetupCategoryIconButton> createState() =>
      _SetupCategoryIconButtonState(name, id, icon);
}

class _SetupCategoryIconButtonState extends State<SetupCategoryIconButton> {
  String name;
  String id;
  bool clicked = false;
  IconData icon;

  _SetupCategoryIconButtonState(this.name, this.id, this.icon);

  @override
  Widget build(BuildContext context) {
    if (clicked == true) {
      return Container(
          height: 65,
          width: 65,
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: TextButton(
              onPressed: () {
                Provider.of<SetupCategoriesViewModel>(context, listen: false)
                    .removeSetupCategory(
                        ArticleCategory(categoryId: id, categoryName: name));

                Provider.of<SetupCategoriesViewModel>(context, listen: false)
                    .decrease();
                clicked = false;
              },
              style: TextButton.styleFrom(primary: Colors.grey),
              child: FaIcon(
                icon,
                size: 20,
                color: Colors.white,
              )));
    } else {
      return Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: TextButton(
              onPressed: () {
                Provider.of<SetupCategoriesViewModel>(context, listen: false)
                    .addSetupCategory(
                        ArticleCategory(categoryId: id, categoryName: name));

                Provider.of<SetupCategoriesViewModel>(context, listen: false)
                    .increase();
                clicked = true;
              },
              style: TextButton.styleFrom(primary: Colors.grey),
              child: FaIcon(
                icon,
                size: 20,
                color: Colors.black,
              )));
    }
  }
}
