// ignore_for_file: dead_code

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:food_delivery_app/Restuarant/Menu/addMenu.dart';
import 'package:food_delivery_app/Restuarant/Menu/deleteMenu.dart';

class menu extends StatefulWidget {
  const menu({Key? key}) : super(key: key);

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  @override
  Widget build(BuildContext context) {
    final foodid = TextEditingController();
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
                    return Dismissible(
                        key: Key(index.toString()),
                        child: Card(
                            elevation: 1,
                            child: ListTile(
                                dense: false,
                                title: Text((documentSnapshot != null)
                                    ? (documentSnapshot['name'])
                                    : " "),
                                subtitle: Text((documentSnapshot != null)
                                    ? (documentSnapshot['description'] != null)
                                        ? documentSnapshot['description']
                                        : ''
                                    : ''),
                                trailing: Image.network(
                                    documentSnapshot!['imageurl'],
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100),
                                leading: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color:
                                        const Color.fromARGB(255, 104, 88, 87),
                                    onPressed: () {
                                      foodname.text = documentSnapshot['name'];
                                      fooddescription.text =
                                          documentSnapshot["description"];
                                      foodingredients.text =
                                          documentSnapshot['ingredients'];
                                      foodquantity.text =
                                          documentSnapshot['quantity'];
                                      foodprice.text =
                                          documentSnapshot['price'];
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Colors.red,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: ListView(
                                                          shrinkWrap: true,
                                                          children: [
                                                            Container(),
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
                                                                      const EdgeInsets
                                                                          .all(26),
                                                                  onPressed:
                                                                      () {
                                                                    snapshot
                                                                        .data
                                                                        ?.docs[
                                                                            index]
                                                                        .reference
                                                                        .update({
                                                                      'name': foodname
                                                                          .text,
                                                                      'description':
                                                                          fooddescription
                                                                              .text,
                                                                      'ingredients':
                                                                          foodingredients
                                                                              .text,
                                                                      'price':
                                                                          foodprice
                                                                              .text,
                                                                      'quantity':
                                                                          foodquantity
                                                                              .text
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
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: s,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
    );
  }
}
