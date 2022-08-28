// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SliderImage extends StatefulWidget {
  const SliderImage({Key? key}) : super(key: key);

  @override
  State<SliderImage> createState() => _SliderImageState();
}

class _SliderImageState extends State<SliderImage> {
  User? user = FirebaseAuth.instance.currentUser;
  final order = FirebaseFirestore.instance.collection("orders");
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("menu").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError|| snapshot.data == null) {
               return const Center(child:Text("ምንም አይነት ምግብ አልተለቀቀም"));           
          } else if (snapshot.hasData || snapshot.data != null) {
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
                int quantity = 1;
                String total = name;
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  alignment: const Alignment(0.5, 0.8),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(documentSnapshot['imageurl'])),                   
                      border: Border.all(color: Colors.red, width: 5),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,                    
                    children:<Widget>[Row(
                    mainAxisAlignment: MainAxisAlignment.center,                  
                    children: <Widget>[
                      Text(total,
                          style: const TextStyle(                             
                              backgroundColor: Color(0xff9c28b1),
                               fontWeight: FontWeight.bold)),
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
                            style: TextStyle(backgroundColor: Color.fromARGB(255,156,40,177), color: Colors.black),
                            
                          )),
                    ],
                  ),ElevatedButton(onPressed: (){}, child: Text('read'))]) // your button beneath text
                );
              },
            );}
            return const Center();
          
        });
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
