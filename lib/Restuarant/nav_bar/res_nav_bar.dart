import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:food_delivery_app/Restuarant/Menu/Menu.dart';
import 'package:food_delivery_app/Restuarant/feedback.dart';
import 'package:food_delivery_app/Restuarant/home.dart';
import 'package:food_delivery_app/Restuarant/vieworder.dart';
import 'package:food_delivery_app/app_setting/policies.dart';
import 'package:food_delivery_app/app_setting/settings.dart';

class res_nav_bar extends StatelessWidget {
  const res_nav_bar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Majet'),
            accountEmail: Text('fetomedanit@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                'O',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.menu),
            title: Text('Menu'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => menu()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => home()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart_rounded),
            title: Text('View Order'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => res_view_order()));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('feedback'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => res_feedback()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => settings()));
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Policies'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => policies()));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
