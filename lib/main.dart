import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/Customer/home.dart';
import 'package:food_delivery_app/consts/themedark.dart';
import 'package:food_delivery_app/firebase_options.dart';
import 'package:food_delivery_app/provider/authprovider.dart';
import 'package:food_delivery_app/provider/darkthem.dart';

import 'package:food_delivery_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'Restuarant/nav_bar/bottombar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    print('called ,mmmmm');
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  void initState() {
    getCurrentAppTheme();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.debugCheckInvalidValueType = null;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            return themeChangeProvider;
          }),
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),
        ],
        child: Consumer<DarkThemeProvider>(
            builder: (context, themeChangeProvider, ch) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MAJET',
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: const CustHome(),
          );
        }));
  }
}
