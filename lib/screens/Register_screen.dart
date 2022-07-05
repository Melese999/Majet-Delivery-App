import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final database = FirebaseDatabase.instance.ref();
  var regName ='/^[a-zA-Z]+ [a-zA-Z]+/';
  final _formkey = GlobalKey<FormState>();
  var firstNameEditingController = new TextEditingController();
  var lastNameEditingController = new TextEditingController();
  var emailEditingController = new TextEditingController();
  final phoneEditingcontroller = new TextEditingController();
  var passwordEditingController = new TextEditingController();
  var confirmpasswordEditingController = new TextEditingController();
  var usernameEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firstnamefield = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(15, 20, 10, 10),
          labelText: 'First Name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
    final lastnamefield = TextFormField(
        autofocus: false,
        controller: lastNameEditingController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          lastNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "Last Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Last Name is required';
          }
          return null;
        });
    final usernamefield = TextFormField(
        autofocus: false,
        controller: usernameEditingController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          usernameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "Username",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter username';
          }
          return null;
        });
    final emailfield = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            contentPadding: EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if(value!.isEmpty){
            return 'please enter email';
          }
           if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value!)) {
            return 'invalid email';
          }
          return null;
        });
    final phonefield = TextFormField(
        autofocus: false,
        controller: usernameEditingController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          usernameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "Username",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter username';
          }
          return null;
        });
     
    final passwordfield = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final confirmpasswordfield = TextFormField(
        autofocus: false,
        controller: confirmpasswordEditingController,
        obscureText: true,
        onSaved: (value) {
          confirmpasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "Confirm Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final resetButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffF96501),
      child: MaterialButton(
        onPressed: () {
          firstNameEditingController.clear();
          lastNameEditingController.clear();
          usernameEditingController.clear();
          emailEditingController.clear();
          passwordEditingController.clear();
          confirmpasswordEditingController.clear();
        },
        child: const Text(
          "Clear Form",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: "TimenewsRoman"),
        ),
      ),
    );
    final signupButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffF96501),
      child: MaterialButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
          }
          if (firstNameEditingController.text.isNotEmpty &&
              lastNameEditingController.text.isNotEmpty &&
              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(emailEditingController.text)&&
              usernameEditingController.text.isNotEmpty &&
              passwordEditingController.text.length > 6 &&
              passwordEditingController.text ==
              confirmpasswordEditingController.text) {
            insertedData(
                firstNameEditingController.text,
                lastNameEditingController.text,
                usernameEditingController.text,
                emailEditingController.text,
                passwordEditingController.text);
          }
        },
        child: const Text(
          "Sign Up",
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
                                      child: Text("Create Account",
                                          style: TextStyle(
                                              color: Color(0xffF96501),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25))),
                                  const SizedBox(height: 45),
                                  firstnamefield,
                                  const SizedBox(height: 25),
                                  lastnamefield,
                                  const SizedBox(height: 25),
                                  usernamefield,
                                  const SizedBox(height: 25),
                                  emailfield,
                                  const SizedBox(height: 25),
                                  phonefield,
                                  const SizedBox(height: 25),
                                  passwordfield,
                                  const SizedBox(height: 25),
                                  confirmpasswordfield,
                                  const SizedBox(height: 20),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        const SizedBox(height: 25),
                                        resetButton,
                                        const SizedBox(height: 25),
                                        signupButton
                                      ]),
                                ])))))));
  }

  void insertedData(String firstname, String lastname, String username,
      String email, String password) {
    database.child("users").push().set({
      "firstname": firstname,
      "lastname": lastname,
      "username": username,
      "email": email,
      "password": password
    });
    firstNameEditingController.clear();
    lastNameEditingController.clear();
    usernameEditingController.clear();
    emailEditingController.clear();
    passwordEditingController.clear();
    confirmpasswordEditingController.clear();
  }
}
