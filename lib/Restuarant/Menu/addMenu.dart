// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:food_delivery_app/services/globalmethods.dart';
import 'package:image_picker/image_picker.dart';

import '../../consts/colors.dart';

class AddMenu extends StatefulWidget {
  static const routeName = '/SignUpScreen';
  @override
  // ignore: library_private_types_in_public_api
  _AddMenu createState() => _AddMenu();
}

class _AddMenu extends State<AddMenu> {
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _ingredientsFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  final picker = ImagePicker();
  String _FoodId = '';
  String _foodName = '';
  String _description = '';
  String _ingredients = '';
  late double _price = '' as double;
  late int _quantity = '' as int;
  late File _pickedImage = File('your initial file');
  late String url = '';
  final _formKey = GlobalKey<FormState>();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();
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
      _pickedImage = '' as File;
    });
    Navigator.pop(context);
  }

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";

    if (isValid!) {
      _formKey.currentState?.save();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
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
  } /*
          final ref = FirebaseStorage.instance
              .ref()
              .child('usersImages')
              .child(_fullName + '.jpg');
          await ref.putFile(_pickedImage);
          url = await ref.getDownloadURL();
          await _auth.createUserWithEmailAndPassword(
              email: _emailAddress.toLowerCase().trim(),
              password: _password.trim());
          final User? user = _auth.currentUser;
          final _uid = user?.uid;
          user?.updateProfile(photoURL: url, displayName: _fullName);
          user?.reload();
          await FirebaseFirestore.instance.collection('users').doc(_uid).set({
            'id': _uid,
            'name': _fullName,
            'email': _emailAddress,
            'phoneNumber': _phoneNumber,
            'imageUrl': url,
            'joinedAt': formattedDate,
            'createdAt': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } 
      }
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // ignore: prefer_const_constructors
                Padding(
                    padding: const EdgeInsets.fromLTRB(
                        50, 50, 50, 25), //apply padding to all four sides
                    child: const Text("Add Any Food ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25))),
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 30),
                      child: CircleAvatar(
                        radius: 105,
                        backgroundColor: ColorsConsts.gradiendLEnd,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: ColorsConsts.gradiendFEnd,
                          backgroundImage: _pickedImage == null
                              ? null
                              : FileImage(_pickedImage),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 190,
                        left: 170,
                        child: RawMaterialButton(
                          elevation: 10,
                          fillColor: ColorsConsts.gradiendLEnd,
                          child: Icon(Icons.add_a_photo),
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          ColorsConsts.title),
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          ColorsConsts.title),
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                        ))
                  ],
                ),
                Form(
                    key: _formKey,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(200, 15, 300, 15),
                        child: TextFormField(
                          key: ValueKey('Id'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'id cannot be null';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_idFocusNode),
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            labelText: 'food id',
                          ),
                          onSaved: (value) {
                            _FoodId = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(200, 15, 300, 15),
                        child: TextFormField(
                          key: ValueKey('foodName'),
                          focusNode: _nameFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please neter food name';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_nameFocusNode),
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            labelText: 'Food name',
                          ),
                          onSaved: (value) {
                            _foodName = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(200, 15, 300, 15),
                        child: TextFormField(
                          key: ValueKey('descrption'),
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            hintText: 'please enter the food decription',
                          ),
                          onSaved: (value) {
                            _description = value!;
                          },
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(200, 15, 300, 15),
                        child: TextFormField(
                          key: ValueKey('ingredients'),
                          keyboardType: TextInputType.text,
                          focusNode: _ingredientsFocusNode,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            hintText: 'please enter some ingredients',
                          ),
                          onSaved: (value) {
                            _description = value!;
                          },
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_ingredientsFocusNode),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(200, 15, 300, 15),
                        child: TextFormField(
                          key: ValueKey('price'),
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: true,
                              labelText: ' food price'),
                          onSaved: (value) {
                            _description = value!;
                          },
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_priceFocusNode),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(200, 15, 300, 15),
                        child: TextFormField(
                          key: ValueKey('quantity'),
                          focusNode: _quantityFocusNode,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textInputAction: TextInputAction.next,
                          onEditingComplete: _submitForm,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: true,
                              labelText: 'quantity'),
                          onSaved: (value) {
                            _quantity = int.parse(value!);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10),
                          _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                          color: ColorsConsts.backgroundColor),
                                    ),
                                  )),
                                  onPressed: _submitForm,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Add',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 25),
                                      ),
                                    ],
                                  ))
                        ],
                      ),
                    ]))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
