// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/AllActor/Admin/home.dart';
import 'package:food_delivery_app/AllActor/Customer/home.dart';
import 'package:food_delivery_app/AllActor/Restuarant/nav_bar/bottombar.dart'; 
import 'package:food_delivery_app/screens/Register_screen.dart';
import 'package:food_delivery_app/services/fire_auth.dart';
import 'package:food_delivery_app/services/restpass.dart';
import 'package:food_delivery_app/services/user.dart'; 

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FireAuth sens = FireAuth();
  bool _odscureText = true;
  final _formkey = GlobalKey<FormState>();
  final  userNamecontroller =   TextEditingController();
  final  passwordcontroller =   TextEditingController();
  final fire = FirebaseFirestore.instance.collection("menu");

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
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value!.isEmpty) {
            return 'please enter email';
          }
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return 'invalid email';
          }
          return null;
        });
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
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value!.isEmpty) {
            return 'please enter password';
          }
          if (value.length < 7) {
            return 'minimum character is 7';
          }
          return null;
        });

    final LoginButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffF96501),
      child: MaterialButton(
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            setState(() {});
            signIn(userNamecontroller.text, passwordcontroller.text);
          }
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
        backgroundColor: const Color(0xffFFC4A2),
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
                        usernamefield,
                        const SizedBox(height: 25),
                        passwordfield,
                        const SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              resetPassword()));
                                },
                                child: const Text(
                                  "Forget Password",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ]),
                        const SizedBox(height: 10),
                        LoginButton,
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

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) {
          User? user = FirebaseAuth.instance.currentUser;
          UserModel loggedInUser = UserModel();
          FirebaseFirestore.instance
              .collection("Alluser") //.where('uid', isEqualTo: user!.uid)
              .doc(user!.uid)
              .get()
              .then((value) {
            loggedInUser = UserModel.fromMap(value.data());
          }).whenComplete(() {
            if (loggedInUser.role == 'restuarant') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomBarScreen()));
            } else if(loggedInUser.role == 'user') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CustHome()));
            } else if(loggedInUser.role == 'admin') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AdminHome()));
            } else if(loggedInUser.role == 'delivery') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CustHome()));
            }
          });           
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
           ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No user found for that email.")));
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
           ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Wrong password provided for that user.")));
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
