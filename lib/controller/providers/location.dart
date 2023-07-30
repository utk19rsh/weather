import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/controller/permission.dart';
import 'package:weather/utils/functions/convertors.dart';

class LocationProvider extends ChangeNotifier {
  Permissions permissions = Permissions();
  String address = "";
  late Position _location;
  List<String> listOfCities = [];

  Future<bool> hasPermission() async =>
      await Geolocator.isLocationServiceEnabled();

  resetAddress() {
    address = "";
    notifyListeners();
  }

  updateAddress(String input) {
    address = input;
    notifyListeners();
  }

  inception() async {
    resetAddress();
    await _getCurrentLocation();
  }

  _getCurrentLocation() async {
    if (await hasPermission()) {
      if (await permissions.requestLocation()) {
        Position position =
            await GeolocatorPlatform.instance.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 0,
            timeLimit: Duration(minutes: 2),
          ),
        );
        _location = position;
        await _getAddressFromLatLng();
      } else {
        await permissions.requestLocation();
      }
    } else {
      address = "Paris";
      notifyListeners();
    }
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _location.latitude,
        _location.longitude,
        localeIdentifier: "en_IN",
      );
      Placemark placeMark = placemarks[0];
      String? subLocality = placeMark.subLocality;
      String? throughfare = placeMark.thoroughfare;
      if (subLocality != null && subLocality.isNotEmpty) {
        address = subLocality;
      } else if (throughfare != null && throughfare.isNotEmpty) {
        address = throughfare;
      }
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getListOfCities(BuildContext context) async {
    Map<String, dynamic> map = await Convertor().extractJson(
      context,
      "assets/json/cities.json",
    );
    List<dynamic> cities = map["cities"];
    for (int i = 0; i < cities.length; i++) {
      listOfCities.add(cities[i]["City"]);
    }
    listOfCities = listOfCities.toSet().toList();
    notifyListeners();
  }
}
