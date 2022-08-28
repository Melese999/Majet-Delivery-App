// ignore_for_file: dead_code, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/AllActor/Restuarant/Menu/addMenu.dart';

class feedback extends StatefulWidget {
  const feedback({Key? key}) : super(key: key);

  @override
  State<feedback> createState() => _feedbackState();
}

class _feedbackState extends State<feedback> {
  User? check = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback page')),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Feedback").snapshots(),
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
                                  title:
                                      Text((documentSnapshot['description'])))));
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
