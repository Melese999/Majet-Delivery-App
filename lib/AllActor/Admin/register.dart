// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/consts/colors.dart';
import 'package:food_delivery_app/services/fire_auth.dart';
import 'package:food_delivery_app/services/globalmethods.dart';
import 'package:food_delivery_app/services/user.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _ingredientsFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  final picker = ImagePicker();
  FireAuth xx = FireAuth();
  final firestore = FirebaseFirestore.instance.collection("users");
    var imagefile = FirebaseStorage.instance.ref().child('images.jpg');
  //final database = FirebaseDatabase.instance.ref();
  var regName = '/^[a-zA-Z]+ [a-zA-Z]+/';
  var firstNameEditingController = TextEditingController();
  var lastNameEditingController = TextEditingController();
  var emailEditingController = TextEditingController();
  var phoneEditingController = TextEditingController();
  var restuarantEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();
  String role = 'restuarant';
  File? _pickedImage;
  late String? url = '';
  final _formKey = GlobalKey<FormState>();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalMethods _globalMethods = GlobalMethods();


  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _idFocusNode.dispose();
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _ingredientsFocusNode.dispose();
    _priceFocusNode.dispose();
    _quantityFocusNode.dispose();
    super.dispose();
  }

  void _remove() {
    setState(() {
      _pickedImage = null;
    });
    Navigator.pop(context);
  }

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      _formKey.currentState?.save();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {

            FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: emailEditingController.text, password: 'res1234')
                .then((value) {
              saveRestuarantToDb(
                  firstNameEditingController.text,
                  lastNameEditingController.text,
                  restuarantEditingController.text,
                  phoneEditingController.text,
                  descriptionEditingController.text,
                  emailEditingController.text,
                  role);
            });
          });
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.toString(), context);
        print('error occured ${error.toString()}');
      } finally {
        setState(() {
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstnamefield = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
          labelText: 'First Name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
    final lastnamefield = TextFormField(
        autofocus: false,
        controller: lastNameEditingController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          lastNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_circle),
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "Last Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Last Name is required';
          }
          return null;
        });
    final emailfield = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
            labelText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value!.isEmpty) {
            return 'please enter email';
          }
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return 'invalid email';
          }
          return null;
        });
    final restuarantname = TextFormField(
      autofocus: false,
      controller: restuarantEditingController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        restuarantEditingController.text = value!;
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
          labelText: 'Restuarant Name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter   the name of your restuarant';
        }
        return null;
      },
    );
    final descriptionField = TextFormField(
      autofocus: false,
      controller: descriptionEditingController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        descriptionEditingController.text = value!;
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
          labelText: 'Description',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please describe your restuarant';
        }
        return null;
      },
    );
    final phonefield = TextFormField(
      autofocus: false,
      controller: phoneEditingController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        phoneEditingController.text = value!;
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
          labelText: 'phone',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter phone number';
        }
        return null;
      },
    );
    final selectedfield = DropdownButtonFormField(
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(         
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        focusedBorder: OutlineInputBorder(          
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        filled: true,
      ),
      value: role,
      onChanged: (String? newValue) {
        setState(() {
          role = newValue!;
        });
      },
      items: <String>['restuarant', 'admin', 'delivery']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 20),
          ),
        );
      }).toList(),
    );
    final resetButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: const Color(0xffF96501),
      child: MaterialButton(
        onPressed: () {
          firstNameEditingController.clear();
          lastNameEditingController.clear();
          emailEditingController.clear();
          restuarantEditingController.clear();
          phoneEditingController.clear();      
        },
        child: const Text(
          "Clear Form",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: "TimenewsRoman"),
        ),
      ),
    );
    final signupButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: const Color(0xffF96501),      
      child: MaterialButton(
        onPressed: _submitForm,
        child: const Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: "TimenewsRoman"),
        ),
      ),
    );

    return Scaffold(
        appBar: AppBar(
            title: const Text("Registeration page"),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )),
        backgroundColor: const Color(0xffFFC4A2),
        body: Stack(children: [
          SingleChildScrollView(
              child: Column(
            children: [  
              const Padding(
                  padding: EdgeInsets.fromLTRB(
                      50, 0, 50, 25), //apply padding to all four sides
                  child: Text("Register",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25))),
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: CircleAvatar(
                      radius: 105,
                      backgroundColor: ColorsConsts.gradiendLEnd,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: ColorsConsts.gradiendFEnd,
                        backgroundImage: _pickedImage == null
                            ? null
                            : FileImage(_pickedImage!) as ImageProvider,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 190,
                      left: 170,
                      child: RawMaterialButton(
                        elevation: 10,
                        fillColor: ColorsConsts.gradiendLEnd,
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Choose option',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: ColorsConsts.gradiendLStart),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        InkWell(
                                          onTap: _pickImageGallery,
                                          splashColor: Colors.purpleAccent,
                                          child: Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.purpleAccent,
                                                ),
                                              ),
                                              Text(
                                                'Gallery',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorsConsts.title),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: _remove,
                                          splashColor: Colors.purpleAccent,
                                          child: Row(
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              Text(
                                                'Remove',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.red),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: const Icon(Icons.add_a_photo),
                      ))
                ],
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.red, width: 5),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 25),
                                firstnamefield,
                                const SizedBox(height: 25),
                                lastnamefield,
                                const SizedBox(height: 25),
                                restuarantname,
                                const SizedBox(height: 25),
                                descriptionField,
                                const SizedBox(height: 25),
                                emailfield,
                                const SizedBox(height: 25),
                                phonefield,
                                const SizedBox(height: 25),
                                selectedfield,
                                const SizedBox(height: 25),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const SizedBox(height: 25),
                                      resetButton,
                                      const SizedBox(height: 25),
                                      signupButton
                                    ])
                              ]))))
            ],
          ))
        ]));
  }
  Future<void> saveRestuarantToDb(
      String firstname,
      String lastname,
      String restuarantName,
      String phone,
      String description,
      String email,
      String role) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();
    userModel.email = email;
    userModel.uid = user!.uid;
    userModel.role = role;
    userModel.toMap();
    await firebaseFirestore.collection("Alluser").doc(user.uid).set({
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "restuarantName": restuarantName,
      "phone": phone,
      "description": description,
      'role': role
    });
    firstNameEditingController.clear();
    lastNameEditingController.clear();
    phoneEditingController.clear();
    restuarantEditingController.clear();
    emailEditingController.clear();
    descriptionEditingController.clear();
    return;
  }
}
