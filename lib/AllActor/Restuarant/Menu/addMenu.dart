import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/consts/colors.dart';
import 'package:food_delivery_app/services/globalmethods.dart';
import 'package:image_picker/image_picker.dart';
 

class AddMenu extends StatefulWidget {
  const AddMenu({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _AddMenu createState() => _AddMenu();
}

class _AddMenu extends State<AddMenu> {
  User? e = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance.collection("menu");

  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _ingredientsFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  final picker = ImagePicker();
  final foodid = TextEditingController();
  final foodname = TextEditingController();
  final fooddescription = TextEditingController();
  final foodingredients = TextEditingController();
  final foodprice = TextEditingController();
  final foodquantity = TextEditingController();
  File? _pickedImage;
  late String url = '';
  final _formKey = GlobalKey<FormState>();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;

  void _pickImageCamera() async {
    final pickedImage =
        await picker.getImage(source: ImageSource.camera, imageQuality: 10);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

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

  Future<void> addMenuTofirestore(String id, String name, String description,
      String ingredients, String price, String quantity) async {
    var name = foodname.text;
    var imagefile = FirebaseStorage.instance.ref().child('images/$name.jpg');
    await imagefile.putFile(_pickedImage!);
    url = await imagefile.getDownloadURL();

    firestore.add({
      'restuarant': e!.email,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'price': price,
      'quantity': quantity,
      'imageurl': url
    });
    foodid.clear();
    foodname.clear();
    fooddescription.clear();
    foodingredients.clear();
    foodprice.clear();
    foodquantity.clear();
    return;
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
            _isLoading = true;
            addMenuTofirestore(
              foodid.text.toString(),
              foodname.text.toString(),
              fooddescription.text.toString(),
              foodingredients.text.toString(),
              foodprice.text.toString(),
              foodquantity.text.toString(),
            );
          });
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.toString(), context);
        print('error occured ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodnamefield = TextFormField(
        autofocus: false,
        controller: foodname,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          foodname.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: "food Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'food Name is required';
          }
          return null;
        });
    final descriptionfield = TextFormField(
        autofocus: false,
        controller: fooddescription,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          fooddescription.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: "description",
            hintText: "please describe the food ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter description';
          }
          return null;
        });
    final ingredintsfield = TextFormField(
      autofocus: false,
      controller: foodingredients,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        foodingredients.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          labelText: "ingredients",
          hintText: "enter the ingredients",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final pricefield = TextFormField(
        autofocus: false,
        controller: foodprice,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        onSaved: (value) {
          foodprice.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: "price",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter price';
          }
          return null;
        });

    final quanttityfield = TextFormField(
        autofocus: false,
        controller: foodquantity,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSaved: (value) {
          foodquantity.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: "quantity",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
    final resetButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffF96501),
      child: MaterialButton(
        onPressed: () {
          foodname.clear();
          fooddescription.clear();
          foodingredients.clear();
          foodprice.clear();
          foodquantity.clear();
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
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loading')),
            );
            _submitForm();
          }
        },
        child: const Text(
          "Add",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: "TimenewsRoman"),
        ),
      ),
    );
    return Scaffold(
        appBar: AppBar(
            title: const Text("Add Menu"),
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
              // ignore: prefer_const_constructors
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      50, 0, 50, 25), //apply padding to all four sides
                  child: const Text("Add Any Food ",
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
                                          onTap: _pickImageCamera,
                                          splashColor: Colors.purpleAccent,
                                          child: Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.camera,
                                                  color: Colors.purpleAccent,
                                                ),
                                              ),
                                              Text(
                                                'Camera',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorsConsts.title),
                                              )
                                            ],
                                          ),
                                        ),
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
                                foodnamefield,
                                const SizedBox(height: 25),
                                descriptionfield,
                                const SizedBox(height: 25),
                                ingredintsfield,
                                const SizedBox(height: 25),
                                pricefield,
                                const SizedBox(height: 25),
                                quanttityfield,
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
}
