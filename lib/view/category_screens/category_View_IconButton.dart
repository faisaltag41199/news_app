import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/model/model/category_model.dart';
import 'package:newsapp/viewmodel/Categories_viewmodel.dart';
import 'package:provider/provider.dart';

class CategoryViewIconButton extends StatefulWidget {
  String name;
  String id;
  IconData icon;
  bool clicked = false;

  CategoryViewIconButton(
      {Key? key, required this.name, required this.id, required this.icon})
      : super(key: key);

  @override
  State<CategoryViewIconButton> createState() =>
      _CategoryViewIconButtonState(name, id, icon);
}

class _CategoryViewIconButtonState extends State<CategoryViewIconButton> {
  String name;
  String id;
  late bool clicked;
  IconData icon;

  _CategoryViewIconButtonState(this.name, this.id, this.icon);

  @override
  void initState() {
    initClickedStatus();
    super.initState();
  }

  initClickedStatus() {
    int? clickedStatus =
        Provider.of<CategoriesViewModel>(context, listen: false)
            .categoriesList
            .indexWhere((element) => element.categoryId == id);
    clicked = clickedStatus != -1 ? true : false;
  }

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
                Provider.of<CategoriesViewModel>(context, listen: false)
                    .removeCategory(
                        ArticleCategory(categoryId: id, categoryName: name));
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
                Provider.of<CategoriesViewModel>(context, listen: false)
                    .addCategory(
                        ArticleCategory(categoryId: id, categoryName: name));
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
