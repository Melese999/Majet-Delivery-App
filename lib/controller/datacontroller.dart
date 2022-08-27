import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  Future getData(String collection) async {
    final FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await firebasefirestore.collection(collection).get();
    return snapshot.docs;
  }

  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('Alluser')
        .where('restuarantName',isEqualTo: queryString).get();
  }
}
