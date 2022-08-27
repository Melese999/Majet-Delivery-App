 // ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use

 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery_app/AllActor/Customer/cus_feedback.dart';
import 'package:food_delivery_app/AllActor/Customer/home.dart';
import 'package:food_delivery_app/AllActor/Customer/order.dart';
import 'package:food_delivery_app/AllActor/Customer/viewMenu.dart';
import 'package:food_delivery_app/app_setting/settingss.dart';
import 'package:food_delivery_app/provider/darkthem.dart';
import 'package:food_delivery_app/screens/login_screen.dart';
import 'package:food_delivery_app/services/Accounts.dart'; 
import 'package:list_tile_switch/list_tile_switch.dart'; 
import 'package:provider/provider.dart';

class Cusnavbar extends StatefulWidget {
  const Cusnavbar({Key? key}) : super(key: key);

  @override
  State<Cusnavbar> createState() => _CusnavbarState();
}

class _CusnavbarState extends State<Cusnavbar> {
  User? auth = FirebaseAuth.instance.currentUser;
  List<String> all = [];
  @override
  void initState() {
    getResdata();
    super.initState();
  }
  Account loggedInUser = Account();
  Future<DocumentSnapshot> getResdata() async {
    var firestore = await FirebaseFirestore.instance
        .collection("Alluser")
        .doc(auth!.uid)
        .get()
        .then((value) {
      loggedInUser = Account.fromMap(value.data());
    });

    return firestore;
  }

  Future exitDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('do you want exit from the app'),
        actions: [
          FlatButton(
            child: const Text("EXIT"),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
          FlatButton(
            child: const Text("CANCEL"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return WillPopScope(
        onWillPop: () {
          exitDialog();
          return Future.value(false);
        },
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(loggedInUser.firstName.toString()),
                accountEmail: Text(auth!.email.toString()),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(
                    'M',
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.menu),
                title: const Text('Menu'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ViewMenu()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustHome()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_shopping_cart_rounded),
                title: const Text('View Order'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ViewOrder()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('feedback'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Cus_Feedback()));
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Settingss()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('logout'),
                onTap: () async {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  });
                },
              ),
              ListTileSwitch(
                value: themeChange.darkTheme,
                leading: const Icon(Ionicons.md_moon),
                onChanged: (value) {
                  setState(() {
                    themeChange.darkTheme = value;
                  });
                },
                visualDensity: VisualDensity.comfortable,
                switchType: SwitchType.cupertino,
                switchActiveColor: Colors.indigo,
                title: const Text('Dark theme'),
              ),
              const Divider(),
              ListTile(
                title: const Text('Exit'),
                leading: const Icon(Icons.exit_to_app),
                onTap: () {
                  exitDialog();
                },
              ),
            ],
          ),
        ));
  }
}
