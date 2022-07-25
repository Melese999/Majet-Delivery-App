
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery_app/AllActor/Restuarant/Menu/Menu.dart';
import 'package:food_delivery_app/AllActor/Restuarant/feedback.dart';
import 'package:food_delivery_app/AllActor/Restuarant/home.dart';
import 'package:food_delivery_app/AllActor/Restuarant/vieworder.dart'; 
import 'package:food_delivery_app/consts/myicons.dart';

 

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  // List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
final List  pages = [
      const home(),
      const menu(),
      const res_view_order(),
      const res_feedback(),   
    ];
 
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedPageIndex], //_pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomAppBar(
        // color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: kBottomNavigationBarHeight * 0.98,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              backgroundColor: Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).textSelectionColor,
              selectedItemColor: Colors.purple,
              currentIndex: _selectedPageIndex,
              // selectedLabelStyle: TextStyle(fontSize: 16),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(MyAppIcons.home),
                  // title: Text('Home'),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                    icon: Icon(MyAppIcons.bag), label: 'menu'),
                 
                BottomNavigationBarItem(
                    icon: Icon(
                      MyAppIcons.cart,
                    ),
                    label: 'order'),
                BottomNavigationBarItem(
                    icon: Icon(MyAppIcons.user), label: 'feedback'),
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}