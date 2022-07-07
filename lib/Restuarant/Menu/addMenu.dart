// ignore_for_file: camel_case_types

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class addMenu extends StatefulWidget {
  const addMenu({Key? key}) : super(key: key);

  @override
  State<addMenu> createState() => _addMenuState();
}

class _addMenuState extends State<addMenu> {
  final database = FirebaseDatabase.instance.ref();
  var regName = '/^[a-zA-Z]+ [a-zA-Z]+/';
  final _formkey = GlobalKey<FormState>();
  var foodId = new TextEditingController();
  var foodName = new TextEditingController();
  var description = new TextEditingController();
  final ingredients = new TextEditingController();
  final quantity = new TextEditingController();
  var price = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final foodIdField = TextFormField(
      autofocus: false,
      controller: foodId,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        foodId.text = value!;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 20, 10, 10),
          labelText: 'Food Name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter food name';
        }
        return null;
      },
    );
    final foodNameField = TextFormField(
        autofocus: false,
        controller: foodName,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          foodName.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "Food Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'FoodName is required';
          }
          return null;
        });
    final descrptionField = TextFormField(
        autofocus: false,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(Icons.person, size: 40.0, color: Colors.white),
            ),
            hintText: "Input your opinion",
            hintStyle: TextStyle(color: Colors.white30),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(new Radius.circular(25.0))),
            labelStyle: TextStyle(color: Colors.white)),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25.0,
        ),
        controller: description,
        validator: (value) {
          if (value!.isEmpty) {
            return "Empty value";
          }
        });
          final ingredientsfield = TextFormField(
        autofocus: false,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(Icons.person, size: 40.0, color: Colors.white),
            ),
            hintText: "Input your opinion",
            hintStyle: TextStyle(color: Colors.blueGrey),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(new Radius.circular(25.0))),
            labelStyle: TextStyle(color: Colors.white)),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 25.0,
        ),
        controller: description,
        validator: (value) {
          if (value!.isEmpty) {
            return "Empty value";
          }
        });

    final priceField = TextFormField(
        autofocus: false,
        controller: price,
        obscureText: true,
        onSaved: (value) {
          price.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "price",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final resetButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffF96501),
      child: MaterialButton(
        onPressed: () {
          foodId.clear();
          foodName.clear();
          description.clear();
          ingredients.clear();
          price.clear();
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
        },
        child: const Text(
          "Add",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: "TimenewsRoman"),
        ),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Add Menu'),
        ),
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
                                  foodIdField,
                                  const SizedBox(height: 25),
                                  foodNameField,
                                  const SizedBox(height: 25),
                                  descrptionField,
                                  const SizedBox(height: 25),
                                  ingredientsfield,
                                  const SizedBox(height: 25),
                                  priceField,
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
  }

