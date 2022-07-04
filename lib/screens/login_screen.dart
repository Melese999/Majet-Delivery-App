import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/Register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController userNamecontroller = new TextEditingController();
  final TextEditingController passwordcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usernamefield = TextFormField(
        autofocus: false,
        controller: userNamecontroller,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          userNamecontroller.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            contentPadding: EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: 'email',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final passwordfield = TextFormField(
        autofocus: false,
        controller: passwordcontroller,
        obscureText: true,
        onSaved: (value) {
          passwordcontroller.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: 'password',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final LoginButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffF96501),
      child: MaterialButton(
        onPressed: () {},
        child: Text(
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
                 margin: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.red,
                           width: 5),
                        borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 60, 15, 60),
                child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            height: 25,
                            child: Text(
                              'Login',
                              textAlign: TextAlign.center,
                            )),
                        SizedBox(height: 45),
                        usernamefield,
                        SizedBox(height: 25),
                        passwordfield,
                        SizedBox(height: 25),
                        LoginButton,
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Do not have an account?"),
                            GestureDetector(
                              onTap: () {                               
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterScreen()));
                              },
                              child: Text(
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
