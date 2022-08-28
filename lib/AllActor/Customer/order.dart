// ignore_for_file: non_constant_identifier_names, avoid_print, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/AllActor/Customer/payment.dart';

class ViewOrder extends StatefulWidget {
  const ViewOrder({Key? key}) : super(key: key);
  @override
  State<ViewOrder> createState() => _ViewOrder();
}

class _ViewOrder extends State<ViewOrder> {
  User? check = FirebaseAuth.instance.currentUser;
  final finalorder = FirebaseFirestore.instance.collection('bankAccount');
  final petCollection = FirebaseFirestore.instance.collection("orders");
  TextEditingController customername = TextEditingController();
  TextEditingController account = TextEditingController();
  double totalprice = 0.0;
  List<int> count = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  double AllTotal = 0.0;
  @override
  Widget build(BuildContext context) {
    final accountfield = TextFormField(
        autofocus: false,
        controller: account,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          account.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "Account",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final namefield = TextFormField(
      autofocus: false,
      controller: customername,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        customername.text = value!;
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
    return Scaffold(
      appBar: AppBar(title: const Text('order page')),
      body: Column(children: [
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("orders").snapshots(),
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

                          int quantity = documentSnapshot!['quantity'];
                          double price = documentSnapshot['price'];
                          if (documentSnapshot['customer'] == check!.email) {
                            double total = quantity * price;
                            return Container(
                                height: 120,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                                                            'quantity':
                                                                quantity,
                                                          });
                                                        }
                                                      });
                                                    },
                                                    child: const Icon(Icons
                                                        .remove_circle_outlined)),
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
                                                        if (count[index] == 0) {
                                                          AllTotal +=
                                                              price * quantity;
                                                        }
                                                        count[index] = 5;
                                                        AllTotal +=
                                                            documentSnapshot[
                                                                'price'];
                                                        quantity++;
                                                        snapshot
                                                            .data
                                                            ?.docs[index]
                                                            .reference
                                                            .update({
                                                          'quantity': quantity,
                                                        });
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.add_circle_outlined,
                                                    )),
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        AllTotal -=
                                                            documentSnapshot[
                                                                    'price'] *
                                                                quantity;
                                                        FirebaseFirestore
                                                            .instance
                                                            .runTransaction(
                                                                (Transaction
                                                                    myTransaction) async {
                                                          myTransaction.delete(
                                                              snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .reference);
                                                        });
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
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
                        }));
              }
              return const Center();
            }),
      ]),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 65,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: (() async {
                  bool x = false;
                  QuerySnapshot allPrice = await FirebaseFirestore.instance
                      .collection("orders")
                      .get();
                  for (var element in allPrice.docs) {
                    if (check?.email == element.get('customer') && x == false) {
                      x = true;
                      print(element.get('price') * element.get('quantity'));
                      totalprice +=
                          element.get('price') * element.get('quantity');
                    }
                    else if (check?.email == element.get('customer') &&x==true) {                      
                      totalprice += element.get('price');
                    }
                  }
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.red, width: 5),
                                  borderRadius: BorderRadius.circular(0)),
                              child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListView(shrinkWrap: true, children: [
                                    Text(
                                      "the overall price is $totalprice",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "TimenewsRoman"),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    namefield,
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    accountfield,
                                    Material(
                                        elevation: 0,
                                        borderRadius: BorderRadius.circular(30),
                                        child: MaterialButton(
                                          padding: const EdgeInsets.all(26),
                                          onPressed: () async {
                                            QuerySnapshot snap =
                                                await FirebaseFirestore.instance
                                                    .collection('bankAccount')
                                                    .get();
                                            for (var element in snap.docs) {
                                              if (customername.text ==
                                                      element
                                                          .get('accountName') &&
                                                  account.text ==
                                                      element.get(
                                                          'accountNumber')) {
                                                print('object');
                                                double yy = element
                                                        .get('accountBalance') -
                                                    AllTotal;
                                                finalorder
                                                    .doc(element.id)
                                                    .update(
                                                        {'accountBalance': yy});
                                              }
                                            }
                                          },
                                          child: const Text(
                                            "pay",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xffF96501),
                                                fontSize: 25,
                                                fontFamily: "TimenewsRoman"),
                                          ),
                                        )),
                                  ])))));
                }),
                child: const Text("place order")),
          ],
        ),
      ),
    );
  }
}
