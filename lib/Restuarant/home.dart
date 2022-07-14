import 'package:flutter/material.dart';
import 'package:food_delivery_app/Restuarant/nav_bar/res_nav_bar.dart';
import 'package:food_delivery_app/provider/darkthem.dart';
import 'package:provider/provider.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _menuState();
}

class _menuState extends State<home> {
  @override
  Widget build(BuildContext context) {
      final themestate = Provider.of<DarkThemeProvider>(context);
      bool isdark = themestate.darkTheme;
    return const Scaffold(
     
        );
  }
}
