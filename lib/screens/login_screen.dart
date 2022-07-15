import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/Restuarant/home.dart';
import 'package:food_delivery_app/Restuarant/nav_bar/bottombar.dart';
import 'package:food_delivery_app/screens/Register_screen.dart';
import 'package:food_delivery_app/services/fire_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FireAuth sens = FireAuth();
  bool _odscureText = true;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController userNamecontroller = new TextEditingController();
  final TextEditingController passwordcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usernamefield = TextFormField(
        autofocus: false,
        controller: userNamecontroller,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          userNamecontroller.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: 'email',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final passwordfield = TextFormField(
        autofocus: false,
        controller: passwordcontroller,
        obscureText: _odscureText,
        onSaved: (value) {
          passwordcontroller.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _odscureText = !_odscureText;
                });
              },
              child:
                  Icon(_odscureText ? Icons.visibility : Icons.visibility_off),
            ),
            prefixIcon: const Icon(Icons.vpn_key),
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: 'password',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final LoginButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffF96501),
      child: MaterialButton(
        onPressed: () async {
          FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: userNamecontroller.text,
                  password: passwordcontroller.text)
              .then((value) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) =>   BottomBarScreen()));
          });
        },
        child: const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: "TimenewsRoman"),
        ),
      ),
    );
    return Scaffold(
        backgroundColor: Color(0xffFFC4A2),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.red, width: 5),
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 60, 15, 60),
                child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                            height: 25,
                            child: Text(
                              'Login',
                              textAlign: TextAlign.center,
                            )),
                        const SizedBox(height: 45),
                        ggahdghaghdghghfghagdfghghfghafhgfghsfsjdf
                        usernamefield,
                        const SizedBox(height: 25),
                        passwordfield,
                        const SizedBox(height: 25),
                        LoginButton,
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Do not have an account?"),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterScreen()));
                              },
                              child: const Text(
                                "create Account",
                                style: TextStyle(
                                    color: Color(0xffF96501),
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ),
        ));
  }
}
