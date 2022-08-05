// ignore_for_file: dead_code, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewMenu extends StatefulWidget {
  const ViewMenu({Key? key}) : super(key: key);

  @override
  State<ViewMenu> createState() => _ViewMenu();
}

class _ViewMenu extends State<ViewMenu> {
  User? check = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
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
                      return Container(
                          height: 120,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: Stack(children: [
                              Row(children: [
                                SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child: Image.network(
                                      documentSnapshot!['imageurl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      documentSnapshot['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(documentSnapshot['price'].toString()),
                                  ],
                                )
                              ]),
                              const Positioned(
                                right: 0.0,
                                bottom: 30.0,
                                child:  
                                    Text('ADD' ,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),),
                                    
                                        
                                
                                ),
                             
                            ]),
                          ));
                    });
                return Container();
              }
              return const Center();
            }));
  }
}
