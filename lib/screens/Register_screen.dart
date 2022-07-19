 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/provider/authprovider.dart';
import 'package:food_delivery_app/screens/login_screen.dart';
import 'package:food_delivery_app/services/fire_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _odscureText = true;
  FireAuth xx = FireAuth();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection("users");
  //final database = FirebaseDatabase.instance.ref();
  var regName = '/^[a-zA-Z]+ [a-zA-Z]+/';
  final _formkey = GlobalKey<FormState>();
  var firstNameEditingController = TextEditingController();
  var lastNameEditingController = TextEditingController();
  var emailEditingController = TextEditingController();
  var adressEditingController = TextEditingController();
  var passwordEditingController = TextEditingController();
  var confirmpasswordEditingController = TextEditingController();
  var usernameEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<AuthProvider>(context, listen: false);
    final firstnamefield = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
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
            prefixIcon: const Icon(Icons.account_circle),
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
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
            prefixIcon: const Icon(Icons.account_circle),
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
            prefixIcon: const Icon(Icons.email),
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "Email",
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
    final phonefield = TextFormField(
        autofocus: false,
        maxLines: 3,
        controller: adressEditingController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          adressEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.contact_mail_outlined),
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "vendors",
            suffixIcon: IconButton(
              icon: const Icon(Icons.location_searching),
              onPressed: () {
                adressEditingController.text = 'locating ...\n please wait ...';
                _userData.getCurrentAdress().then((address) {
                  if (address != null) {
                    setState(() {
                      adressEditingController.text =
                          '${_userData.placeName}\n${_userData.resAdress}';
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('couldnot find location ... try agin')));
                  }
                });
              },
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'please press navigation button';
          }
          if (_userData.resLatitude == null) {
            return 'please press navigation button';
          }
          return null;
        });

    final passwordfield = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: _odscureText,
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
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
            labelText: "password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final confirmpasswordfield = TextFormField(
        autofocus: false,
        controller: confirmpasswordEditingController,
        obscureText: _odscureText,
        onSaved: (value) {
          confirmpasswordEditingController.text = value!;
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
            labelText: "Confirm Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final resetButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: const Color(0xffF96501),
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
      color: const Color(0xffF96501),
      child: MaterialButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );

            _userData
                .registerRestuarant(
                    emailEditingController.text, passwordEditingController.text)
                .then((credential) {
              if (credential.user!.uid != null) {
                _userData.saveRestuarantToDb(
                    firstNameEditingController.text,
                    lastNameEditingController.text,
                    passwordEditingController.text);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("_userData.error")));
              }
            });
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
        appBar: AppBar(
            leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        )),
        backgroundColor: const Color(0xffFFC4A2),
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
/*
  
    firstNameEditingController.clear();
    lastNameEditingController.clear();
    usernameEditingController.clear();
    emailEditingController.clear();
    passwordEditingController.clear();
    confirmpasswordEditingController.clear();
    */
}
