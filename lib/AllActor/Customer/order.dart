import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewOrder extends StatefulWidget {
  const ViewOrder({Key? key}) : super(key: key);
  @override
  State<ViewOrder> createState() => _ViewOrder();
}

class _ViewOrder extends State<ViewOrder> {
  User? check = FirebaseAuth.instance.currentUser;
  double AllTotal = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('order page')),
        body: Column(children: [
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("orders").snapshots(),
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
                        int quantity = documentSnapshot!['quantity'];
                        double price = documentSnapshot['price'];
                        if (documentSnapshot['customer'] == check!.email) {
                          double total = quantity * price;
                          z= total;
                          return Container(
                              height: 120,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                child: Stack(
                                  children: [
                                    Row(children: [
                                      SizedBox(
                                        height: 120,
                                        width: 120,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 20, 0),
                                          child: Image.network(
                                            documentSnapshot['foodimage'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            documentSnapshot['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(documentSnapshot['price']
                                              .toString()),
                                          const SizedBox(height: 50),
                                          Text("calculated price $total")
                                        ],
                                      )
                                    ]),
                                    Positioned(
                                      right: 0.0,
                                      bottom: 0.0,
                                      child: Row(children: [
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (documentSnapshot[
                                                              'quantity'] <
                                                          1) {
                                                        snapshot
                                                            .data
                                                            ?.docs[index]
                                                            .reference
                                                            .update({
                                                          'ShouldVisible':
                                                              !documentSnapshot[
                                                                  'ShouldVisible']
                                                        });
                                                      } else {
                                                        if (AllTotal > 0) {
                                                          AllTotal -=
                                                              documentSnapshot[
                                                                  'price'];
                                                        }
                                                        quantity--;
                                                        snapshot
                                                            .data
                                                            ?.docs[index]
                                                            .reference
                                                            .update({
                                                          'quantity': quantity,
                                                        });
                                                      }
                                                    });
                                                  },
                                                  child:
                                                      const Icon(Icons.remove)),
                                              Text(
                                                quantity.toString(),
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      AllTotal +=
                                                          documentSnapshot[
                                                              'price'];                                                    
                                                      quantity++;
                                                      snapshot.data?.docs[index]
                                                          .reference
                                                          .update({
                                                        'quantity': quantity,
                                                      });
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.add,
                                                  )),
                                            ],
                                          ),
                                        )
                                      ]),
                                    ),
                                  ],
                                ),
                              ));
                        }
                        return Container();
                      });
                }
                return const Center();
              }),
          Text("the overall price is $AllTotal"),
          ElevatedButton(onPressed: (() {}), child: const Text("place order")),
        ]));
  }
}
