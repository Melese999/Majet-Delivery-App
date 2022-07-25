import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustHome extends StatefulWidget {
  const CustHome({Key? key}) : super(key: key);

  @override
  State<CustHome> createState() => _CustHomeState();
}

class _CustHomeState extends State<CustHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar( 
        elevation: 0,
        leading: Container() ,
        title: const Text('CustHome Page'),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize:Size.fromHeight(56),
          child:Padding(
            padding: EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'search your favorite restuarant',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(                 
                borderSide: BorderSide.none,                     
              ),
              contentPadding:EdgeInsets.zero,
              filled:true,
              fillColor: Colors.white,
              
            ),
          ),
          )
           ),

      )  
    );
  }
}
