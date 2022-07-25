import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/provider/authprovider.dart';
import 'package:food_delivery_app/screens/login_screen.dart';
import 'package:food_delivery_app/services/fire_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class resetPassword extends StatefulWidget {
  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  FireAuth xx = FireAuth();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection("users");
  //final database = FirebaseDatabase.instance.ref();

  final _formkey = GlobalKey<FormState>();

  var emailEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context, listen: false);

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
            hintText: 'enter registered email',
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
    final resetButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: const Color(0xffF96501),
      child: MaterialButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            userData.resetPass(emailEditingController.text);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          }
        },
        child: const Text(
          "Reset password",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: "TimenewsRoman"),
        ),
      ),
    );

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        )),
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
                                      child: Text("Reset password",
                                          style: TextStyle(
                                              color: Color(0xffF96501),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25))),
                                  const SizedBox(height: 45),
                                  RichText(
                                    text: const TextSpan(
                                      text: '',
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Forget Password',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red)),
                                        TextSpan(
                                            text:
                                                'we will sent you reset link to your email',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  emailfield,
                                  const SizedBox(height: 20),
                                  resetButton
                                ])))))));
  }
}
