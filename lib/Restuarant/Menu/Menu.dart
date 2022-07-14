// ignore_for_file: dead_code

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:food_delivery_app/Restuarant/Menu/addMenu.dart';

class menu extends StatefulWidget {
  const menu({Key? key}) : super(key: key);

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  /*
  @override
  void initState() {
    crudObj.getdata().then((results) {
      setState(() {
        menus = results;
      });
    });
  }
*/
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
                    return Dismissible(
                        key: Key(index.toString()),
                        child: Card(
                         
                          elevation: 4,
                          child: ListTile(                                                                                 
                            title: Text((documentSnapshot != null)
                                ? (documentSnapshot['name'])
                                : " "),
                            subtitle: Text((documentSnapshot != null)
                                ? (documentSnapshot['description'] != null)
                                    ? documentSnapshot['description']
                                    : ''
                                : ''),
                                leading: Image.network(
                    documentSnapshot!['imageurl'],
                    fit: BoxFit.fill,
                    width: 50,
                    height: 50,
                    ),
                                trailing:   IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: const Color.fromARGB(255, 104, 88, 87), 
                                  onPressed: () {  },
                                  
                                ),
                          ),
                        ));
                  });
            }
            return const Center();
          }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const AddMenu()));
          }),
    );
  }
}
