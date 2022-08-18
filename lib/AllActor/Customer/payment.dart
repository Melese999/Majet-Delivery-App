// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/fire_auth.dart';

class MakePayment extends StatefulWidget {
  const MakePayment({Key? key}) : super(key: key);

  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  FireAuth xx = FireAuth();
  final firestore = FirebaseFirestore.instance.collection("Account");
  double total = 600;

  CollectionReference finals =
      FirebaseFirestore.instance.collection('PlacedOrder');

  final _formkey = GlobalKey<FormState>();
  var Customername = TextEditingController();
  var Account = TextEditingController();
  @override
  Widget build(BuildContext context) {
    finals.get();
    finals.snapshots();

    final namefield = TextFormField(
      autofocus: false,
      controller: Customername,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        Customername.text = value!;
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
          labelText: 'Name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
    final emailfield = TextFormField(
        autofocus: false,
        controller: Account,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          Account.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "Account",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final resetButton = Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xffF96501),
        child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("Account").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("something went wrong");
              } else if (snapshot.hasData || snapshot.data != null) {
                return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          QueryDocumentSnapshot<Object?>? documentSnapshot =
                              snapshot.data?.docs[index];
                          return MaterialButton(
                            onPressed: () {
                              double acc = double.parse(Account.text);
                              double totals =
                                  documentSnapshot!['balance'] - total;
                              if (documentSnapshot['name'] ==
                                      Customername.text &&
                                  acc == documentSnapshot['account']) {
                                snapshot.data?.docs[index].reference
                                    .update({'balance': totals}).then((value) {
                                  print('object');
                                });
                              }
                            },
                            child: const Text(
                              "pay",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontFamily: "TimenewsRoman"),
                            ),
                          );
                        }));
              }
              return Container();
            }));

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
                                      child: Text("payment",
                                          style: TextStyle(
                                              color: Color(0xffF96501),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25))),
                                  const SizedBox(height: 20),
                                  namefield,
                                  const SizedBox(height: 20),
                                  emailfield,
                                  const SizedBox(height: 20),
                                  resetButton
                                ])))))));
  }
}
