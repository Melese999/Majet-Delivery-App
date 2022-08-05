// ignore_for_file: dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 
 

class res_view_order extends StatefulWidget {
  const res_view_order({Key? key}) : super(key: key);

  @override
  State<res_view_order> createState() => _res_view_order();
}

class _res_view_order extends State<res_view_order> {
  User? check = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final foodname = TextEditingController();
    final fooddescription = TextEditingController();
    final foodingredients = TextEditingController();
    final foodprice = TextEditingController();
    final foodquantity = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Order page')),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("orders").snapshots(),
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
                                  title: Text((documentSnapshot!['name'])),
                                  subtitle: Column(children: [
                                    Text(
                                      documentSnapshot['price'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Color(0xffF96501),
                                          fontSize: 15,
                                          fontFamily: "TimenewsRoman"),
                                    ),
                                    
                                                                 
                                  ]),
                                  trailing: Image.network(
                                      documentSnapshot['foodimage'],
                                      fit: BoxFit.cover,
                                      height: 400,
                                      width: 100), 
                                  leading: IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: const Color.fromARGB(
                                          255, 104, 88, 87),
                                     onPressed: (){}, 
                                      ))));});}

                                      return Container();}));
                    
                    
               
             
          }
   
  }
 
 
