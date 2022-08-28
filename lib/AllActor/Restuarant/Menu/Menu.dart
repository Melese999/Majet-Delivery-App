// ignore_for_file: dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/AllActor/Restuarant/Menu/addMenu.dart';

class menu extends StatefulWidget {
  const menu({Key? key}) : super(key: key);

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  User? check = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final foodname = TextEditingController();
    final fooddescription = TextEditingController();
    final foodingredients = TextEditingController();
    final foodprice = TextEditingController();
    final foodquantity = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Menu page')),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("menu").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("something went wrong");
            } else if (snapshot.hasData || snapshot.data != null) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    QueryDocumentSnapshot<Object?>? documentSnapshot =
                        snapshot.data?.docs[index];
                    if (documentSnapshot!['restuarant'] == check!.email) {
                      return Dismissible(
                          key: Key(index.toString()),
                          child: Card(
                              elevation: 1,
                              child: ListTile(
                                  dense: false,
                                  title: Text((documentSnapshot['name'])),
                                  subtitle: Column(children: [
                                    Text(
                                      documentSnapshot['description'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Color(0xffF96501),
                                          fontSize: 15,
                                          fontFamily: "TimenewsRoman"),
                                    ),
                                    Text(
                                      documentSnapshot['ingredients'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Color(0xffF96501),
                                          fontSize: 15,
                                          fontFamily: "TimenewsRoman"),
                                    ),
                                    Text(
                                      documentSnapshot['price'].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Color(0xffF96501),
                                          fontSize: 15,
                                          fontFamily: "TimenewsRoman"),
                                    ),
                                    Text(
                                      documentSnapshot['quantity'].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Color(0xffF96501),
                                          fontSize: 15,
                                          fontFamily: "TimenewsRoman"),
                                    )
                                  ]),
                                  trailing: Image.network(
                                      documentSnapshot['imageurl'],
                                      fit: BoxFit.cover,
                                      height: 400,
                                      width: 100),
                                  leading: IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: const Color.fromARGB(
                                          255, 104, 88, 87),
                                      onPressed: () {
                                        foodname.text =
                                            documentSnapshot['name'];
                                        fooddescription.text =
                                            documentSnapshot["description"];
                                        foodingredients.text =
                                            documentSnapshot['ingredients'];
                                        foodquantity.text =
                                            documentSnapshot['quantity']
                                                .toString();
                                        foodprice.text =
                                            documentSnapshot['price']
                                                .toString();
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: Colors.red,
                                                            width: 5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0)),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: ListView(
                                                            shrinkWrap: true,
                                                            children: [
                                                              const Text(
                                                                "Edit The food ",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        "TimenewsRoman"),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              _buildTextField(
                                                                  foodname,
                                                                  'Name'),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              _buildTextField(
                                                                  fooddescription,
                                                                  'description'),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              _buildTextField(
                                                                  foodingredients,
                                                                  'ingredients'),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              _buildTextField(
                                                                  foodquantity,
                                                                  'quantity'),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              _buildTextField(
                                                                  foodprice,
                                                                  'price'),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Material(
                                                                  elevation: 0,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                  child:
                                                                      MaterialButton(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            26),
                                                                    onPressed:
                                                                        () {
                                                                      if (foodname.text.isNotEmpty &&
                                                                          foodingredients
                                                                              .text
                                                                              .isNotEmpty &&
                                                                          fooddescription
                                                                              .text
                                                                              .isNotEmpty &&
                                                                          foodprice
                                                                              .text
                                                                              .isNotEmpty &&
                                                                          foodquantity
                                                                              .text
                                                                              .isNotEmpty) {
                                                                        snapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                            .reference
                                                                            .update({
                                                                          'name':
                                                                              foodname.text,
                                                                          'description':
                                                                              fooddescription.text,
                                                                          'ingredients':
                                                                              foodingredients.text,
                                                                          'price':
                                                                              double.parse(foodprice.text),
                                                                          'quantity':
                                                                              int.parse(foodquantity.text)
                                                                        });
                                                                        foodname
                                                                            .clear();
                                                                        fooddescription
                                                                            .clear();
                                                                        foodingredients
                                                                            .clear();
                                                                        foodprice
                                                                            .clear();
                                                                        foodquantity
                                                                            .clear();
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      "update",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xffF96501),
                                                                          fontSize:
                                                                              25,
                                                                          fontFamily:
                                                                              "TimenewsRoman"),
                                                                    ),
                                                                  )),
                                                            ])),
                                                  ),
                                                ));
                                      }))));
                    }
                    return Container();
                  });
            }

            return const Center();
          }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddMenu()));
          }),
    );
  }

  _buildTextField(TextEditingController controller, String s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextFormField(
          onSaved: (value) {
            controller.text = value!;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          controller: controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: s,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
    );
  }
}
