// ignore_for_file: camel_case_types, library_private_types_in_public_api, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class registerAccount extends StatefulWidget {
  const registerAccount({Key? key}) : super(key: key);

  @override
  _registerAccountState createState() => _registerAccountState();
}
class _registerAccountState extends State<registerAccount> {
  final firestore = FirebaseFirestore.instance.collection("BankAccount");
  final _formkey = GlobalKey<FormState>();
  var Customername = TextEditingController();
  var Account = TextEditingController();
  var balamce = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
          labelText: 'Account Name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
    final Accountfield = TextFormField(
        autofocus: false,
        controller: Account,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        onSaved: (value) {
          Account.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_balance),
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "Account number",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final balancefield = TextFormField(
        autofocus: false,
        controller: balamce,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        onSaved: (value) {
          balamce.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.balance),
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "balance",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final AddButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: const Color(0xffF96501),
      child: MaterialButton(
        onPressed: () async {
          await FirebaseFirestore.instance.collection("BankAccount").add({
            'accountName': Customername.text,
            'accountNumber': Account.text,
            'accountBalance': double.parse(balamce.text)
          });
        },
        child: const Text(
          "register",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: "TimenewsRoman"),
        ),
      ),
    );
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
                                      child: Text("Account",
                                          style: TextStyle(
                                              color: Color(0xffF96501),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25))),
                                  const SizedBox(height: 20),
                                  namefield,
                                  const SizedBox(height: 20),
                                  Accountfield,
                                  const SizedBox(height: 20),
                                  balancefield,
                                  const SizedBox(height: 20),
                                  AddButton
                                ])))))));
  }

  showAlertDialog(BuildContext context, String text) {
    // Create button
    Widget okButton = FlatButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Error Occured"),
      content: Text(text),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
