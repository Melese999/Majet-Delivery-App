// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/services/user.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier {
  late double resLatitude;
  late double resLongtiude;
  late String resAdress;
  late String placeName;
  String error = '';
  late String email;

  Future getCurrentAdress() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    resLatitude = _locationData.latitude!;
    resLongtiude = _locationData.longitude!;

    final coordinates =
        Coordinates(_locationData.latitude, _locationData.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var resAdress = addresses.first;
    this.resAdress = resAdress.addressLine;
    placeName = resAdress.featureName;
    notifyListeners();
    return resAdress;
  }

  Future<UserCredential> registerRestuarant(email, password) async {
    UserCredential credential;

    credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    this.email = email;
    notifyListeners();
    return credential;
  }

  Future<UserCredential> loginRes(email, password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  Future<void> resetPass(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      error = e.code;
      notifyListeners();
    } catch (e) {
      error = e.toString();
    }
  }

  Future<void> saveRestuarantToDb(
      String firstname, String lastname, String role) async {
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
    //  "address": '${placeName}:${resAdress}',
     // 'location': GeoPoint(resLatitude, resLongtiude),
      'role': role
    });
    return;
  }
}
