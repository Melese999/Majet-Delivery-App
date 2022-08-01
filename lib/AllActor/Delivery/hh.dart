// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery_app/AllActor/Customer/order.dart';

class dd extends StatefulWidget {
  const dd({Key? key}) : super(key: key);

  @override
  State<dd> createState() => _ddState();
}

class _ddState extends State<dd> {
  User? user = FirebaseAuth.instance.currentUser;
  final order = FirebaseFirestore.instance.collection("orders");
  late String name;
  late String price;
  late String quantity;
  late String restuarantname;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("menu").snapshots(),
        builder: (context, snapshot) {
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: 4,
              itemBuilder: (BuildContext ctx, index) {
                QueryDocumentSnapshot<Object?>? documentSnapshot =
                    snapshot.data?.docs[index];
                String name = documentSnapshot!['name'];
                String quantity = documentSnapshot['quantity'];
                String total = '$name $quantity';
                name = documentSnapshot['name'];
                price = documentSnapshot['price'];
                quantity = documentSnapshot['quantity'];
                restuarantname = documentSnapshot['restuarant'];
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  alignment: const Alignment(0.5, 0.8),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(documentSnapshot['imageurl'])),
                      color: Colors.white,
                      border: Border.all(color: Colors.red, width: 5),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(total,
                          style: const TextStyle(
                              // your text
                              color: Colors.white)),
                      GestureDetector(
                          onTap: () {
                            addOrder();
                          },
                          child: const Text(
                            '  add',
                            style: TextStyle(color: Colors.green),
                          )),
                    ],
                  ), // your button beneath text
                );
              });
        });
  }

  void addOrder() {
    order.add({
      'name': name,
      'price': price,
      'quantity': quantity,
      'restuarant': restuarantname,
      'customer': user?.email
    }).then((value) {});
  }
}
