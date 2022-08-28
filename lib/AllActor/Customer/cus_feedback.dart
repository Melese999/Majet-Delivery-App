// ignore_for_file: camel_case_types, implementation_imports
// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/fire_auth.dart';

class Cus_Feedback extends StatefulWidget {
  const Cus_Feedback({Key? key}) : super(key: key);

  @override
  _Cus_FeedbackState createState() => _Cus_FeedbackState();
}

class _Cus_FeedbackState extends State<Cus_Feedback> {
  User? user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance.collection("Feedback");

  final _formkey = GlobalKey<FormState>();
  var contents = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final content = TextFormField(
      autofocus: false,
      controller: contents,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        contents.text = value!;
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
          labelText: 'feedback',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
    final signupButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: const Color.fromARGB(255, 22, 14, 8),
      child: MaterialButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            firestore.doc(user?.uid).set({
              'description':contents.text,
              'restuarant':user?.email
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('loading Data')),
            );
          }
        },
        child: const Text(
          "submit",
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
                                      child: Text("give your feedback",
                                          style: TextStyle(
                                              color: Color(0xffF96501),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25))),
                                  const SizedBox(height: 20),
                                  content,
                                  const SizedBox(height: 20),
                                  signupButton
                                ])))))));
  }
}
