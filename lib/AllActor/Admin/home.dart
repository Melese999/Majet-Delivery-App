import 'package:flutter/material.dart';
import 'package:food_delivery_app/AllActor/Admin/register.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Admin page')),
        body: Center(
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(30),            
          color: const Color(0xffF96501),
            child: MaterialButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Register()));
          },
          child: const Text(
            "Register",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontFamily: "TimenewsRoman"),
          ),
            ),
          ),
        ));
  }
}
