// ignore_for_file: dead_code, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/AllActor/Customer/cusNavBar.dart';

class ViewMenu extends StatefulWidget {
  const ViewMenu({Key? key}) : super(key: key);

  @override
  State<ViewMenu> createState() => _ViewMenu();
}

class _ViewMenu extends State<ViewMenu> {
  User? check = FirebaseAuth.instance.currentUser;
  @override
  User? user = FirebaseAuth.instance.currentUser;
  final order = FirebaseFirestore.instance.collection("orders");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Cusnavbar(),
      appBar: AppBar(
        elevation: 0,
        title: const Text('CustHome Page'),
        centerTitle: true,
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'search your favorite restuarant',
                  icon:Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            )),
      ),
     body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("menu").snapshots(),
        builder: (context, snapshot) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext ctx, index) {
              QueryDocumentSnapshot<Object?>? documentSnapshot =
                  snapshot.data?.docs[index];
              String name = documentSnapshot!['name'];
              int price = documentSnapshot['quantity'];
              int quantity = 1;
              String total = '$name $price ';
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
                            color: Colors.white,)),
                    GestureDetector(
                        onTap: () {
                          addOrder(
                              documentSnapshot['imageurl'],
                              documentSnapshot['name'],
                              documentSnapshot['price'],
                              quantity,
                              documentSnapshot['restuarant']);
                        },
                        child: const Text(
                          'add',
                          style: TextStyle(color: Colors.green),
                        )),
                  ],
                ), // your button beneath text
              );
            },
          );
        }));
  }
  void addOrder(String image, String name, double price, int quantity,
      String restuarantname) async {
    await order.add({
      'ShouldVisible': false,
      'foodimage': image,
      'name': name,
      'price': price,
      'quantity': quantity,
      'restuarant': restuarantname,
      'customer': user?.email
    }).then((d) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Order Added")));
    });
  }
}

