import 'package:flutter/material.dart';
import 'package:food_delivery_app/Restuarant/nav_bar/res_nav_bar.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _menuState();
}

class _menuState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const res_nav_bar(), appBar: AppBar(title: const Text('Home page')));
  }
}
