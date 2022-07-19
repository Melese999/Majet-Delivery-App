import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class Locationprovider with ChangeNotifier {
  late double latitude;
  late double longtude;

  Future<void> getcurrentposition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      this.latitude = position.latitude;
      longtude = position.longitude;
      notifyListeners();
    } else {
      print("permission not denied");
    }
  }
}
