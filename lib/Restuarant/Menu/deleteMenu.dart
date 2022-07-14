import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/services/globalmethods.dart';
import 'package:image_picker/image_picker.dart';
import '../../consts/colors.dart';

class EditMenu extends StatefulWidget {
  const EditMenu({Key? key}) : super(key: key);

  @override
  State<EditMenu> createState() => _EditMenuState();

    void setintil(String id, String name, String description, String ingredients,
      String price, String quantity) {
    
  }
}

class _EditMenuState extends State<EditMenu> {
  final firestore = FirebaseFirestore.instance.collection("menu");
  var imagefile = FirebaseStorage.instance.ref().child("images");
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

 
  void uploadfoodimage() async {
    String food = foodname.text;
    imagefile.child('.jpg');
    imagefile.putFile(_pickedImage!);
  }
 
  Future<void> addMenuTofirestore(String id, String name, String description,
      String ingredients, String price, String quantity) async {
    url = await imagefile.getDownloadURL();
    firestore.doc('BpMN3KeyXRxxUa8jx1A5').update({
      'id': id,
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
            uploadfoodimage();
            addMenuTofirestore(
                foodid.text.toString(),
                foodname.text.toString(),
                fooddescription.text.toString(),
                foodingredients.text.toString(),
                foodprice.text.toString(),
                foodquantity.text.toString());
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
    final foodidfield = TextFormField(
      autofocus: false,
      controller: foodid,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        foodid.text = value!;
      },
      decoration: InputDecoration(
          labelText: 'food id',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
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
        inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
        inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
          foodid.clear();
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
      color: Color(0xffF96501),
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
            title: const Text("Edit Food"),
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
                  child: const Text("Edit the  Food ",
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
                                const SizedBox(height: 45),
                                foodidfield,
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
  } /*
                    key: _formKey,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(200, 15, 300, 15),
                        child: TextFormField(
                          controller: foodid,
                          key: const ValueKey('Id'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'id cannot be null';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_idFocusNode),
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            labelText: 'food id',
                          ),
                          onSaved: (value) {
                            foodid.text = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(200, 15, 300, 15),
                        child: TextFormField(
                          controller: foodname,
                          key: const ValueKey('foodName'),
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
                            foodname.text = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(200, 15, 300, 15),
                        child: TextFormField(
                          controller: fooddescription,
                          key: const ValueKey('descrption'),
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            hintText: 'please enter the food decription',
                          ),
                          onSaved: (value) {
                            fooddescription.text = value!;
                          },
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(200, 15, 300, 15),
                        child: TextFormField(
                          controller: foodingredients,
                          key: const ValueKey('ingredients'),
                          keyboardType: TextInputType.text,
                          focusNode: _ingredientsFocusNode,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            hintText: 'please enter some ingredients',
                          ),
                          onSaved: (value) {
                            foodingredients.text = value!;
                          },
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_ingredientsFocusNode),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(200, 15, 300, 15),
                        child: TextFormField(
                          controller: foodprice,
                          key: const ValueKey('price'),
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: true,
                              labelText: ' food price'),
                          onSaved: (value) {
                            foodprice.text = value!;
                          },
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_priceFocusNode),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(200, 15, 300, 15),
                        child: TextFormField(
                          controller: foodquantity,
                          key: const ValueKey('quantity'),
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
                            foodquantity.text = value!;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          _isLoading
                              ? const CircularProgressIndicator()
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
                                  onPressed: () async {
                                    addMenuTofirestore(
                                        foodid.text.toString(),
                                        foodname.text.toString(),
                                        fooddescription.text.toString(),
                                        foodingredients.text.toString(),
                                        foodprice.text.toString(),
                                        foodquantity.text.toString());
                                  },
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
  }*/
}
